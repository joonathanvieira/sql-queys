SELECT
  monthname(date(pa.data_transacao)) AS mes,
  count(DISTINCT pa.id) AS clientes,
  CASE WHEN
    DATEDIFF((
               SELECT
                 data_proximo_pagamento AS data_pagamento
               FROM vendas_transacao
               WHERE id = (SELECT MAX(id)
                           FROM vendas_transacao
                           WHERE vendas_transacao.empresa_id = ve.id AND tipo_transacao NOT IN (3, 4, 6) AND
                                 StatusTransacao IN ('Completo'))), NOW()) + 7 >= 0
    THEN
      #calculo do valor do plano de acordo com o valor de ProdValor_1/ProdID_1 onde é pego somento o secundo caracter que indica o tipo de plano (mensal/trimestral/semestral)
      round(sum(pa.ProdValor_1 / cast(substring(pa.ProdID_1, 2) AS SIGNED)), 2)
  ELSE 0 END            AS valor_total
FROM (
       SELECT
         id,
         empresa
       FROM vendas_empresa AS ve1
       WHERE ve1.id IN
             #id's gerados pelo mixpanel de acordo com o utm_source
             (215495,
215567,
215653,
215658,
215743,
215826,
215902,
216453,
216456,
216743,
216994,
217044,
217117,
217152,
217237,
217300,
217591,
217603,
217653,
217736,
217894,
217905,
217948,
218113,
218127,
218185,
218355,
218385,
218397,
218623,
218808,
218861,
218867,
218896,
219170,
219388,
55948)) AS ve
  LEFT JOIN (
              SELECT
                empresa_id,
                MAX(id) AS id
              FROM vendas_transacao
              WHERE StatusTransacao = 'Completo' AND ProdValor_1 > 0
              GROUP BY empresa_id) AS a ON a.empresa_id = ve.id
  LEFT JOIN vendas_transacao AS pa ON pa.id = a.id;
