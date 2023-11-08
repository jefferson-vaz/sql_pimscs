/* Objetivo: Quando executada esta instrução, retorna uma Tabela com Áreas, Toneladas e TCH Encerrados das Ultimas 3 Safras + Safra Atual - Necessário Acrescentrar as novas safras - Tabelas de back-up */

select--fTch
    to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) as "Layer",
    a.cd_upnivel1 as "Mapa",
    a.cd_upnivel2 as "Gleba",
    a.cd_upnivel3 as "Quadra",
    a.cd_fren_tran as "Frente",
    b.dt_ocorren as "Data Fech. Local Prod.",
    sum(a.qt_cana_ent/1000) as "Ton. Cana",
    (sum(a.qt_cana_ent/1000) / d."Ton. Cana Total") as "percent_tc_quadra",
    round((round(c."Area",2) * (sum(a.qt_cana_ent/1000) / d."Ton. Cana Total")),2) as "Area (ha)",
    round((sum(a.qt_cana_ent/1000) / round((round(c."Area",2) * (sum(a.qt_cana_ent/1000) / d."Ton. Cana Total")),2)),2) as "Tch"
from    
    pimscs.histproduc a
inner join
    pimscs.safrupniv3 b on
        a.cd_safra = b.cd_safra and
        a.cd_upnivel1 = b.cd_upnivel1 and
        a.cd_upnivel2 = b.cd_upnivel2 and
        a.cd_upnivel3 = b.cd_upnivel3
left join
    (
    select--Area das Ordens de Corte Fechadas - Safra 2023
        a.cd_safra,
        a.cd_upnivel1,
        a.cd_upnivel2,
        a.cd_upnivel3,
        sum(a.qt_area) as "Area"
    from
        pimscs.queima_de a
    inner join
        pimscs.queima_he b on
            a.no_queima = b.no_queima
    where
       b.fg_situacao = 'F' and
       b.dt_fechamento <= sysdate-1 and
       a.cd_safra = 2023 
    group by
        a.cd_safra, 
        a.cd_upnivel1,
        a.cd_upnivel2, 
        a.cd_upnivel3  
        
    UNION ALL
    
    select--Area das Ordens de Corte Fechadas - Safra 2022
        a.cd_safra,
        a.cd_upnivel1,
        a.cd_upnivel2,
        a.cd_upnivel3,
        sum(a.qt_area) as "Area"
    from
        pimscs.queima_de_2022 a
    inner join
        pimscs.queima_he_2022 b on
            a.no_queima = b.no_queima
    where
       b.fg_situacao = 'F'
    group by
        a.cd_safra, 
        a.cd_upnivel1,
        a.cd_upnivel2, 
        a.cd_upnivel3 
    
    UNION ALL
    
    select--Area das Ordens de Corte Fechadas - Safra 2021
        a.cd_safra,
        a.cd_upnivel1,
        a.cd_upnivel2,
        a.cd_upnivel3,
        sum(a.qt_area) as "Area"
    from
        pimscs.queima_de_2021 a
    inner join
        pimscs.queima_he_2021 b on
            a.no_queima = b.no_queima
    where
       b.fg_situacao = 'F'
    group by
        a.cd_safra, 
        a.cd_upnivel1,
        a.cd_upnivel2, 
        a.cd_upnivel3 

    UNION ALL
    
    select--Area das Ordens de Corte Fechadas - Safra 2020
        a.cd_safra,
        a.cd_upnivel1,
        a.cd_upnivel2,
        a.cd_upnivel3,
        sum(a.qt_area) as "Area"
    from
        pimscs.queima_de_2020 a
    inner join
        pimscs.queima_he_2020 b on
            a.no_queima = b.no_queima
    where
       b.fg_situacao = 'F'
    group by
        a.cd_safra, 
        a.cd_upnivel1,
        a.cd_upnivel2, 
        a.cd_upnivel3
) c on
    a.cd_safra = c.cd_safra and
    a.cd_upnivel1 = c.cd_upnivel1 and
    a.cd_upnivel2 = c.cd_upnivel2 and
    a.cd_upnivel3 = c.cd_upnivel3
left join
    (
    select--Total de Toneladas por Local por Safra
        a.cd_safra,
        a.cd_upnivel1,
        a.cd_upnivel2,
        a.cd_upnivel3,
        sum(a.qt_cana_ent/1000) as "Ton. Cana Total"
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
        a.cd_upnivel1, 
        a.cd_upnivel2, 
        a.cd_upnivel3    
) d on
    a.cd_safra = d.cd_safra and
    a.cd_upnivel1 = d.cd_upnivel1 and
    a.cd_upnivel2 = d.cd_upnivel2 and
    a.cd_upnivel3 = d.cd_upnivel3
where
    b.fg_ocorren = 'F' and
    b.dt_ocorren <= sysdate-1 and
    b.dt_ocorren = 
        (
            select
                max(b2.dt_ocorren)
            from
                pimscs.safrupniv3 b2
            where
                b.cd_safra = b2.cd_safra and
                b.cd_upnivel1 = b2.cd_upnivel1 and
                b.cd_upnivel2 = b2.cd_upnivel2 and
                b.cd_upnivel3 = b2.cd_upnivel3 
    ) and
    a.cd_safra >= 
        (
            select 
                max(cd_safra)-3
            from 
                pimscs.histproduc
    )
group by 
    to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end), 
    a.cd_safra,
    a.cd_upnivel1, 
    a.cd_upnivel2,
    a.cd_upnivel3,
    b.dt_ocorren,
    round(c."Area",2),
    d."Ton. Cana Total",
    a.cd_fren_tran