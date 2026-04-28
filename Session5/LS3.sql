SELECT
    status,
    trust_score,
    distance_km
FROM
    Drivers
WHERE
    status = 'AVAILABLE'
    AND trust_score >= CASE
        WHEN min_trust_score < 0 THEN 0
        WHEN min_trust_score > 100 THEN 100
        ELSE min_trust_score
    END
ORDER BY
    distance_km ASC,
    trust_score DESC;