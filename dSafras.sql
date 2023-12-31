/* Objetivo: Quando executada esta instrução, retorna uma Tabela de Resumo de Safra, das Últimas 4 Safras do Histórico de Produção - Virada Safra Automatica  */

select--dSafra
    a.cd_safra as "No.Safra",
    'Safra ' || a.cd_safra as "Safra",
    min(a.dt_historico) as "Data Inicio",
    max(a.dt_historico) as "Data Final"
from
    pimscs.histproduc a
where
    a.cd_safra >=
        (
            select
                max(cd_safra)-3
            from
                pimscs.histproduc
    ) 
group by 
    a.cd_safra, 
    'Safra ' || a.cd_safra
