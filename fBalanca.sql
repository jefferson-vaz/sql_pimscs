/* Objetivo: Quando executada esta instrução, retorna uma Tabela Entrada de Cana das Ultimas 3 Safras + Safra Atual */

select--Apt_Cargas por Liberação - Safra 2023
    to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) as "Layer",
    a.cd_upnivel1 as "Mapa",
    a.cd_upnivel2 as "Gleba",
    a.cd_upnivel3 as "Quadra",
    a.dt_movimento as "Data",
    a.cd_fren_tran as "Frente Colheita",
    sum(a.qt_liquido/1000) as "Toneladas de Cana",
    sum(a.qt_distancia * (a.qt_liquido/1000)) as "Ponderar Distancia",
    sum(
        case 
            when a.fg_dig_ba is null then 0
            when a.qt_fibra is null then 0
            else (a.qt_fibra * a.qt_liquido)
        end
    ) as "kg_fibra",
    sum(
        case 
            when a.fg_dig_ba is null then 0        
            when a.qt_fibra is null then 0
            when a.qt_fibra = 0 then 0
            else a.qt_liquido
        end
    ) as "ton_fibra",
    sum(
        case 
            when a.fg_dig_ba is null then 0
            when a.qt_pex is null then 0
            else (a.qt_pex * a.qt_liquido)
        end
    ) as "kg_pol",
    sum(
        case 
            when a.fg_dig_ba is null then 0        
            when a.qt_pex is null then 0
            when a.qt_pex = 0 then 0
            else a.qt_liquido
        end
    ) as "ton_pol",
    sum(
        case 
            when a.fg_dig_ba is null then 0
            when a.qt_brix is null then 0
            else (a.qt_brix * a.qt_liquido)
        end
    ) as "kg_brix",
    sum(
        case 
            when a.fg_dig_ba is null then 0        
            when a.qt_brix is null then 0
            when a.qt_brix = 0 then 0
            else a.qt_liquido
        end
    ) as "ton_brix",     
    sum(
        case 
            when a.fg_dig_ba is null then 0
            when a.qt_impur_terra is null then 0
            else a.qt_impur_terra
        end
    ) as "kg_impur_terra",
    sum(
        case 
            when a.fg_dig_ba is null then 0        
            when a.qt_impur_terra is null then 0
            when a.qt_impur_terra = 0 then 0
            else a.qt_liquido
        end
    ) as "ton_impur_terra",   
    sum(
        case 
            when a.fg_dig_ba is null then 0
            when a.qt_impur_veg is null then 0
            else a.qt_impur_veg
        end
    ) as "kg_impur_veg",
    sum(
        case 
            when a.fg_dig_ba is null then 0        
            when a.qt_impur_veg is null then 0
            when a.qt_impur_veg = 0 then 0
            else a.qt_liquido
        end
    ) as "ton_impur_veg"
from
    pimscs.apt_cargas a
inner join
    pimscs.upnivel1 b on
        a.cd_upnivel1 = b.cd_upnivel1
where
    a.cd_unid_ind = 11 and
    a.cd_safra = 2023 and
    a.dt_movimento is not null 
group by  
    to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end), 
    a.cd_upnivel1, 
    a.cd_upnivel2, 
    a.cd_upnivel3, 
    a.dt_movimento, 
    a.cd_fren_tran 

UNION ALL

select--Apt_Cargas por Liberação - Safra 2022
    to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) as "Layer",
    a.cd_upnivel1 as "Mapa",
    a.cd_upnivel2 as "Gleba",
    a.cd_upnivel3 as "Quadra",
    a.dt_movimento as "Data",
    a.cd_fren_tran as "Frente Colheita",
    sum(a.qt_liquido/1000) as "Toneladas de Cana",
    sum(a.qt_distancia * (a.qt_liquido/1000)) as "Ponderar Distancia",
    sum(
        case 
            when a.fg_dig_ba is null then 0
            when a.qt_fibra is null then 0
            else (a.qt_fibra * a.qt_liquido)
        end
    ) as "kg_fibra",
    sum(
        case 
            when a.fg_dig_ba is null then 0        
            when a.qt_fibra is null then 0
            when a.qt_fibra = 0 then 0
            else a.qt_liquido
        end
    ) as "ton_fibra",
    sum(
        case 
            when a.fg_dig_ba is null then 0
            when a.qt_pex is null then 0
            else (a.qt_pex * a.qt_liquido)
        end
    ) as "kg_pol",
    sum(
        case 
            when a.fg_dig_ba is null then 0        
            when a.qt_pex is null then 0
            when a.qt_pex = 0 then 0
            else a.qt_liquido
        end
    ) as "ton_pol",
    sum(
        case 
            when a.fg_dig_ba is null then 0
            when a.qt_brix is null then 0
            else (a.qt_brix * a.qt_liquido)
        end
    ) as "kg_brix",
    sum(
        case 
            when a.fg_dig_ba is null then 0        
            when a.qt_brix is null then 0
            when a.qt_brix = 0 then 0
            else a.qt_liquido
        end
    ) as "ton_brix",     
    sum(
        case 
            when a.fg_dig_ba is null then 0
            when a.qt_impur_terra is null then 0
            else a.qt_impur_terra
        end
    ) as "kg_impur_terra",
    sum(
        case 
            when a.fg_dig_ba is null then 0        
            when a.qt_impur_terra is null then 0
            when a.qt_impur_terra = 0 then 0
            else a.qt_liquido
        end
    ) as "ton_impur_terra",   
    sum(
        case 
            when a.fg_dig_ba is null then 0
            when a.qt_impur_veg is null then 0
            else a.qt_impur_veg
        end
    ) as "kg_impur_veg",
    sum(
        case 
            when a.fg_dig_ba is null then 0        
            when a.qt_impur_veg is null then 0
            when a.qt_impur_veg = 0 then 0
            else a.qt_liquido
        end
    ) as "ton_impur_veg"
from
    pimscs.apt_cargas_2022 a
inner join
    pimscs.upnivel1 b on
        a.cd_upnivel1 = b.cd_upnivel1
where
    a.cd_unid_ind = 11 
group by  
    to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end), 
    a.cd_upnivel1, 
    a.cd_upnivel2, 
    a.cd_upnivel3, 
    a.dt_movimento, 
    a.cd_fren_tran 

UNION ALL

select--Apt_Cargas por Liberação - Safra 2021
    to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) as "Layer",
    a.cd_upnivel1 as "Mapa",
    a.cd_upnivel2 as "Gleba",
    a.cd_upnivel3 as "Quadra",
    a.dt_movimento as "Data",
    a.cd_fren_tran as "Frente Colheita",
    sum(a.qt_liquido/1000) as "Toneladas de Cana",
    sum(a.qt_distancia * (a.qt_liquido/1000)) as "Ponderar Distancia",
    sum(
        case 
            when a.fg_dig_ba is null then 0
            when a.qt_fibra is null then 0
            else (a.qt_fibra * a.qt_liquido)
        end
    ) as "kg_fibra",
    sum(
        case 
            when a.fg_dig_ba is null then 0        
            when a.qt_fibra is null then 0
            when a.qt_fibra = 0 then 0
            else a.qt_liquido
        end
    ) as "ton_fibra",
    sum(
        case 
            when a.fg_dig_ba is null then 0
            when a.qt_pex is null then 0
            else (a.qt_pex * a.qt_liquido)
        end
    ) as "kg_pol",
    sum(
        case 
            when a.fg_dig_ba is null then 0        
            when a.qt_pex is null then 0
            when a.qt_pex = 0 then 0
            else a.qt_liquido
        end
    ) as "ton_pol",
    sum(
        case 
            when a.fg_dig_ba is null then 0
            when a.qt_brix is null then 0
            else (a.qt_brix * a.qt_liquido)
        end
    ) as "kg_brix",
    sum(
        case 
            when a.fg_dig_ba is null then 0        
            when a.qt_brix is null then 0
            when a.qt_brix = 0 then 0
            else a.qt_liquido
        end
    ) as "ton_brix",     
    sum(
        case 
            when a.fg_dig_ba is null then 0
            when a.qt_impur_terra is null then 0
            else a.qt_impur_terra
        end
    ) as "kg_impur_terra",
    sum(
        case 
            when a.fg_dig_ba is null then 0        
            when a.qt_impur_terra is null then 0
            when a.qt_impur_terra = 0 then 0
            else a.qt_liquido
        end
    ) as "ton_impur_terra",   
    sum(
        case 
            when a.fg_dig_ba is null then 0
            when a.qt_impur_veg is null then 0
            else a.qt_impur_veg
        end
    ) as "kg_impur_veg",
    sum(
        case 
            when a.fg_dig_ba is null then 0        
            when a.qt_impur_veg is null then 0
            when a.qt_impur_veg = 0 then 0
            else a.qt_liquido
        end
    ) as "ton_impur_veg"
from
    pimscs.apt_cargas_2021 a
inner join
    pimscs.upnivel1 b on
        a.cd_upnivel1 = b.cd_upnivel1
where
    a.cd_unid_ind = 11 
group by  
    to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end), 
    a.cd_upnivel1, 
    a.cd_upnivel2, 
    a.cd_upnivel3, 
    a.dt_movimento, 
    a.cd_fren_tran 

UNION ALL

select--Apt_Cargas por Liberação - Safra 2020
    to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) as "Layer",
    a.cd_upnivel1 as "Mapa",
    a.cd_upnivel2 as "Gleba",
    a.cd_upnivel3 as "Quadra",
    a.dt_movimento as "Data",
    a.cd_fren_tran as "Frente Colheita",
    sum(a.qt_liquido/1000) as "Toneladas de Cana",
    sum(a.qt_distancia * (a.qt_liquido/1000)) as "Ponderar Distancia",
    sum(
        case 
            when a.fg_dig_ba is null then 0
            when a.qt_fibra is null then 0
            else (a.qt_fibra * a.qt_liquido)
        end
    ) as "kg_fibra",
    sum(
        case 
            when a.fg_dig_ba is null then 0        
            when a.qt_fibra is null then 0
            when a.qt_fibra = 0 then 0
            else a.qt_liquido
        end
    ) as "ton_fibra",
    sum(
        case 
            when a.fg_dig_ba is null then 0
            when a.qt_pex is null then 0
            else (a.qt_pex * a.qt_liquido)
        end
    ) as "kg_pol",
    sum(
        case 
            when a.fg_dig_ba is null then 0        
            when a.qt_pex is null then 0
            when a.qt_pex = 0 then 0
            else a.qt_liquido
        end
    ) as "ton_pol",
    sum(
        case 
            when a.fg_dig_ba is null then 0
            when a.qt_brix is null then 0
            else (a.qt_brix * a.qt_liquido)
        end
    ) as "kg_brix",
    sum(
        case 
            when a.fg_dig_ba is null then 0        
            when a.qt_brix is null then 0
            when a.qt_brix = 0 then 0
            else a.qt_liquido
        end
    ) as "ton_brix",     
    sum(
        case 
            when a.fg_dig_ba is null then 0
            when a.qt_impur_terra is null then 0
            else a.qt_impur_terra
        end
    ) as "kg_impur_terra",
    sum(
        case 
            when a.fg_dig_ba is null then 0        
            when a.qt_impur_terra is null then 0
            when a.qt_impur_terra = 0 then 0
            else a.qt_liquido
        end
    ) as "ton_impur_terra",   
    sum(
        case 
            when a.fg_dig_ba is null then 0
            when a.qt_impur_veg is null then 0
            else a.qt_impur_veg
        end
    ) as "kg_impur_veg",
    sum(
        case 
            when a.fg_dig_ba is null then 0        
            when a.qt_impur_veg is null then 0
            when a.qt_impur_veg = 0 then 0
            else a.qt_liquido
        end
    ) as "ton_impur_veg"
from
    pimscs.apt_cargas_2020 a
inner join
    pimscs.upnivel1 b on
        a.cd_upnivel1 = b.cd_upnivel1
where
    a.cd_unid_ind = 11 
group by  
    to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end), 
    a.cd_upnivel1, 
    a.cd_upnivel2, 
    a.cd_upnivel3, 
    a.dt_movimento, 
    a.cd_fren_tran 