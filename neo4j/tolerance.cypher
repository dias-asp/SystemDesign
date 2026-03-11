MATCH (n)
OPTIONAL MATCH (n)-[r]->(d)
WITH n, count(r) AS dependencies
OPTIONAL MATCH (x)-[r2]->(n)
WITH n, dependencies, count(r2) AS dependents
RETURN
  n.name AS node,
  dependencies,
  dependents,
  CASE
    WHEN (dependencies + dependents) = 0
  THEN 0
    ELSE toFloat(dependencies) / (dependencies + dependents)
    END AS fault_tolerance
  ORDER BY fault_tolerance DESC