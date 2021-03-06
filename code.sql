SELECT
  count(DISTINCT clientes.id) as clientes,
  monthname(clientes.data) as mes_de_pagamento,
  round(sum(clientes.valor/ cast(substring(clientes.plano, 2) AS SIGNED)), 2) as valor_pago

FROM
  (SELECT
     empresa_id      AS id,
     ProdValor_1     AS valor,
     ProdID_1        AS plano,
     ProdDescricao_1 AS info,
     data_transacao  AS data
   FROM vendas_transacao
   WHERE
     empresa_id IN
     (55948, 215495, 215542, 215567, 215653, 215658, 215722, 215743, 215826, 215902, 216453, 216456,
     216592, 216743, 216994, 217044, 217117, 217152, 217237, 217300, 217474, 217591, 217603, 217653,
     217736, 217894, 217905, 217948, 218113, 218127, 218185, 218355, 218385, 218397, 218623, 218682,
     218808, 218861, 218867, 218896, 219170, 219173, 219329, 219388
     )
     AND tipo_transacao NOT IN (3, 4, 6) AND StatusTransacao IN ('Completo') AND ProdValor_1 > 0 AND data_transacao <= '2017-09-30'
  ) AS clientes
GROUP BY 2;
