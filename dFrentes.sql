/* Objetivo: Quando executada esta instrução, retorna uma Tabela de Resumo das Frentes de Colheita das Últimas 4 Safras do Histórico de Produção, Apt_Cargas e Perdas de Colheita Mecânica  */

select--dFrentes
    distinct
    "No. Frente",
    "Frente",
    "Frente Colheita"
from (
    select--dFrentes Histórico de Producao
        distinct
        to_number(a.cd_fren_tran) as "No. Frente",
        case
            when to_number(a.cd_fren_tran) < 10 then 'Frente 0' || a.cd_fren_tran
            else 'Frente ' || a.cd_fren_tran
        end as "Frente",
        case
            when to_number(a.cd_fren_tran) = 9 then 'Frente 0' || a.cd_fren_tran || '(Experimento)'
            when to_number(a.cd_fren_tran) = 15 then 'Frente ' || a.cd_fren_tran || '(SJC Bionergia)'
            when to_number(a.cd_fren_tran) = 12 then 'Frente ' || a.cd_fren_tran || '(S. Junqueira)'
            when to_number(a.cd_fren_tran) = 21 then 'Frente ' || a.cd_fren_tran || '(Aguapei)'
            when to_number(a.cd_fren_tran) < 10 then 'Frente 0' || a.cd_fren_tran
            else 'Frente ' || a.cd_fren_tran
        end as "Frente Colheita"
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
    
    UNION ALL
    
    select--dFrentes Apt_Cargas
        distinct
        to_number(a.cd_fren_tran) as "No. Frente",
        case
            when to_number(a.cd_fren_tran) < 10 then 'Frente 0' || a.cd_fren_tran
            else 'Frente ' || a.cd_fren_tran
        end as "Frente",
        case
            when to_number(a.cd_fren_tran) = 9 then 'Frente 0' || a.cd_fren_tran || '(Experimento)'
            when to_number(a.cd_fren_tran) = 15 then 'Frente ' || a.cd_fren_tran || '(SJC Bionergia)'
            when to_number(a.cd_fren_tran) = 12 then 'Frente ' || a.cd_fren_tran || '(S. Junqueira)'
            when to_number(a.cd_fren_tran) = 21 then 'Frente ' || a.cd_fren_tran || '(Aguapei)'
            when to_number(a.cd_fren_tran) < 10 then 'Frente 0' || a.cd_fren_tran
            else 'Frente ' || a.cd_fren_tran
        end as "Frente Colheita"
    from
        pimscs.apt_cargas a
    where
        a.cd_safra >=
            (
                select
                    max(cd_safra)-3
                from
                    pimscs.apt_cargas
        )
        
    UNION ALL

    select--dFrentes Perdas
        distinct
        to_number(b.cd_fren_tran) as "No. Frente",
        case
            when to_number(b.cd_fren_tran) < 10 then 'Frente 0' || b.cd_fren_tran
            else 'Frente ' || b.cd_fren_tran
        end as "Frente",
        case
            when to_number(b.cd_fren_tran) = 9 then 'Frente 0' || b.cd_fren_tran || '(Experimento)'
            when to_number(b.cd_fren_tran) = 15 then 'Frente ' || b.cd_fren_tran || '(SJC Bionergia)'
            when to_number(b.cd_fren_tran) = 12 then 'Frente ' || b.cd_fren_tran || '(S. Junqueira)'
            when to_number(b.cd_fren_tran) = 21 then 'Frente ' || b.cd_fren_tran || '(Aguapei)'
            when to_number(b.cd_fren_tran) < 10 then 'Frente 0' || b.cd_fren_tran
            else 'Frente ' || b.cd_fren_tran
        end as "Frente Colheita"
    from 
        pimscs.apt_perda_de a
    inner join
        pimscs.apt_perda_he b on
            a.instancia = b.instancia and 
            a.no_boletim = b.no_boletim and 
            a.fg_manmec = b.fg_manmec
    where
        a.cd_safra >=
            (
                select
                    max(cd_safra)-3
                from
                    pimscs.apt_perda_de
        ) 
)
