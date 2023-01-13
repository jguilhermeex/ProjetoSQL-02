-- (Query 1) Gênero dos leads
-- Colunas: gênero, leads(#)

SELECT 
    CASE
        WHEN i.gender = 'male' THEN 'Homens'
         WHEN i.gender = 'female' THEN 'Mulheres'
         END AS genero,
        count(*) as leads
FROM sales.customers as c
LEFT JOIN temp_tables.ibge_genders as i
ON  LOWER(c.first_name) = i.first_name
GROUP BY i.gender
ORDER BY leads DESC


-- (Query 2) Status profissional dos leads
-- Colunas: status profissional, leads (%)

    SELECT
    CASE
        WHEN professional_status = 'freelancer' THEN 'Freelancer'
        WHEN professional_status = 'retired' THEN 'Aposentado'
        WHEN professional_status = 'clt' THEN 'CLT'
        WHEN professional_status = 'self_employed' THEN 'Autônomo'
        WHEN professional_status = 'other' THEN 'Outro'
        WHEN professional_status = 'businessman' THEN 'Empresário'
        WHEN professional_status = 'civil_servant' THEN 'Servidor Público'
        WHEN professional_status = 'student' THEN 'Estudante'
        END AS Status_Profissional,
        (COUNT(*)::float / (SELECT count(*) from sales.customers)) as leads
FROM sales.customers
GROUP BY Status_Profissional
ORDER BY leads DESC


-- (Query 3) Faixa etária dos leads
-- Colunas: faixa etária, leads (%)

SELECT 
       CASE
            WHEN datediff('years', birth_date,current_date) <20 THEN '0-20'
              WHEN datediff('years', birth_date,current_date) <40 THEN '20-40'
                WHEN datediff('years', birth_date,current_date) <60 THEN '40-60'
                  WHEN datediff('years', birth_date,current_date) <80 THEN '60-80'
             ELSE '80+'
             END AS faixa_etaria,
             (count(*)::float / (SELECT count(*) from sales.customers)) as leads
FROM sales.customers
GROUP BY faixa_etaria
ORDER BY leads DESC

-- (Query 4) Faixa salarial dos leads
-- Colunas: faixa salarial, leads (%), ordem
SELECT 
       CASE
            WHEN income <5000 THEN '0-5000'
            WHEN income <10000 THEN '5000-10000'
            WHEN income <15000 THEN '10000-15000'
            WHEN income <20000 THEN '15000-20000'
            ELSE 'Mais de 20000'
            END AS Faixa_salarial,
            count(*)::float / (SELECT count(*) from sales.customers) as leads,
          CASE
            WHEN income <5000 THEN 1
            WHEN income <10000 THEN 2
            WHEN income <15000 THEN 3
            WHEN income <20000 THEN 4
            ELSE 5
            END AS ordem
FROM sales.customers
GROUP BY faixa_salarial, ordem
ORDER BY ordem


-- (Query 5) Classificação dos veículos visitados
-- Colunas: classificação do veículo, veículos visitados (#)
-- Regra de negócio: Veículos novos tem até 2 anos e seminovos acima de 2 anos

SELECT 
        CASE
            WHEN EXTRACT(year from visit_page_date) - model_year::int <2 THEN 'Novo'
            ELSE 'Seminovo'
            END AS classificacao_veiculo,
            COUNT(*) as veiculos
FROM sales.funnel as f
LEFT JOIN sales.products as p
ON f.product_id = p.product_id
GROUP BY classificacao_veiculo


-- (Query 6) Idade dos veículos visitados
-- Colunas: Idade do veículo, veículos visitados (%), ordem

SELECT 
        CASE
            WHEN EXTRACT(year from visit_page_date) - model_year::int <=2 THEN '0-2 anos'
            WHEN EXTRACT(year from visit_page_date) - model_year::int <=4 THEN '2-4 anos'
            WHEN EXTRACT(year from visit_page_date) - model_year::int <=6 THEN '4-6 anos'
            WHEN EXTRACT(year from visit_page_date) - model_year::int <=8 THEN '6-8 anos'
            WHEN EXTRACT(year from visit_page_date) - model_year::int <=10 THEN '8-10 anos'
            ELSE 'Acima de 10 anos'
            END AS idade_veiculo,
            count (*)::float / (SELECT count(*) from sales.customers) as veículos,
             CASE
            WHEN EXTRACT(year from visit_page_date) - model_year::int <=2 THEN 1
            WHEN EXTRACT(year from visit_page_date) - model_year::int <=4 THEN 2
            WHEN EXTRACT(year from visit_page_date) - model_year::int <=6 THEN 3
            WHEN EXTRACT(year from visit_page_date) - model_year::int <=8 THEN 4
            WHEN EXTRACT(year from visit_page_date) - model_year::int <=10 THEN 5
            ELSE 6
            END AS ordem
FROM sales.funnel as f
LEFT JOIN sales.products as p
ON f.product_id = p.product_id
GROUP BY idade_veiculo, ordem
ORDER BY ordem

-- (Query 7) Veículos mais visitados por marca
-- Colunas: brand, model, visitas (#)


SELECT p.brand, p.model, count(f.visit_page_date) as visitas
FROM sales.funnel as f
LEFT JOIN sales.products as p
ON f.product_id = p.product_id
GROUP BY p.brand, p.model
ORDER BY visitas DESC








