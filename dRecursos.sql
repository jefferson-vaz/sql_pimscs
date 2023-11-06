/* Objetivo: Quando executada esta instrução, retorna uma Tabela com Recursos por Local de Produção , nas ultimas três Safras + Safra Atual */

select--dRecursos--Safra 2023
    distinct
    to_number(trim(b.cd_upnivel1)||trim(b.cd_upnivel2)||case when to_number(trim(b.cd_upnivel3)) < 10 then '0'||trim(b.cd_upnivel3) else trim(b.cd_upnivel3) end) as "Layer",
    b.cd_safra as "Safra",
    a.no_liberacao as "No. Liberacao",
    b.no_queima as "No. Ordem Corte",
    case
        when a.cd_tp_recurso = 'TT' then 'Trator Transbordo'
        when a.cd_tp_recurso = 'CD' then 'Colhedora'
        when a.cd_tp_recurso = 'CM' then 'Caminhao Rodotrem'
        when a.cd_tp_recurso = 'TD' then 'Caminhao Dedicado'
    end as "Tipo Equipto",
    to_number(substr(a.cd_equipto,3,6)) as "Equipto",
    substr(a.cd_operador,3,5) || '-' || c.de_func as "Operador",
    d."Noteiro" as "Noteiro",
    e."Lider" as "Lider"
from
    pimscs.apt_cargas_rec a
inner join
    pimscs.apt_cargas b on
        a.no_liberacao = b.no_liberacao
left join
    pimscs.funcionars c on
        a.cd_operador = c.cd_func
left join
    (
    select--dRecursos--Noteiro/Apontador
        distinct
        b.cd_safra as "Safra",
        a.no_liberacao as "No. Liberacao",
        substr(a.cd_operador,3,5) || '-' || c.de_func as "Noteiro"
    from
        pimscs.apt_cargas_rec a
    inner join
        pimscs.apt_cargas b on
            a.no_liberacao = b.no_liberacao
    left join
        pimscs.funcionars c on
            a.cd_operador = c.cd_func
    where
        b.cd_unid_ind = 11 and
        a.cd_tp_recurso = 'CO' and
        b.cd_safra = 2023    
    ) d on
    b.cd_safra = d."Safra" and
    a.no_liberacao = d."No. Liberacao"
left join
    (
    select--dRecursos--Lider
        distinct
        b.cd_safra as "Safra",
        a.no_liberacao as "No. Liberacao",
        substr(a.cd_operador,3,5) || '-' || c.de_func as "Lider"
    from
        pimscs.apt_cargas_rec a
    inner join
        pimscs.apt_cargas b on
            a.no_liberacao = b.no_liberacao
    left join
        pimscs.funcionars c on
            a.cd_operador = c.cd_func
    where
        b.cd_unid_ind = 11 and
        a.cd_tp_recurso = 'FS' and
        b.cd_safra = 2023    
    ) e on
    b.cd_safra = e."Safra" and
    a.no_liberacao = e."No. Liberacao"    
where
    b.cd_unid_ind = 11 and
    a.cd_tp_recurso in ('CD','TT','CM','TD') and
    b.cd_safra = 2023
    
UNION ALL

select--dRecursos--Safra 2022
    distinct
    to_number(trim(b.cd_upnivel1)||trim(b.cd_upnivel2)||case when to_number(trim(b.cd_upnivel3)) < 10 then '0'||trim(b.cd_upnivel3) else trim(b.cd_upnivel3) end) as "Layer",
    b.cd_safra as "Safra",
    a.no_liberacao as "No. Liberacao",
    b.no_queima as "No. Ordem Corte",
    case
        when a.cd_tp_recurso = 'TT' then 'Trator Transbordo'
        when a.cd_tp_recurso = 'CD' then 'Colhedora'
        when a.cd_tp_recurso = 'CM' then 'Caminhao Rodotrem'
        when a.cd_tp_recurso = 'TD' then 'Caminhao Dedicado'
    end as "Tipo Equipto",
    to_number(substr(a.cd_equipto,3,6)) as "Equipto",
    substr(a.cd_operador,3,5) || '-' || c.de_func as "Operador",
    d."Noteiro" as "Noteiro",
    e."Lider" as "Lider"
from
    pimscs.apt_cargas_rec_2022 a
inner join
    pimscs.apt_cargas_2022 b on
        a.no_liberacao = b.no_liberacao
left join
    pimscs.funcionars c on
        a.cd_operador = c.cd_func
left join
    (
    select--dRecursos--Noteiro/Apontador
        distinct
        b.cd_safra as "Safra",
        a.no_liberacao as "No. Liberacao",
        substr(a.cd_operador,3,5) || '-' || c.de_func as "Noteiro"
    from
        pimscs.apt_cargas_rec_2022 a
    inner join
        pimscs.apt_cargas_2022 b on
            a.no_liberacao = b.no_liberacao
    left join
        pimscs.funcionars c on
            a.cd_operador = c.cd_func
    where
        b.cd_unid_ind = 11 and
        a.cd_tp_recurso = 'CO'    
    ) d on
    b.cd_safra = d."Safra" and
    a.no_liberacao = d."No. Liberacao"
left join
    (
    select--dRecursos--Lider
        distinct
        b.cd_safra as "Safra",
        a.no_liberacao as "No. Liberacao",
        substr(a.cd_operador,3,5) || '-' || c.de_func as "Lider"
    from
        pimscs.apt_cargas_rec_2022 a
    inner join
        pimscs.apt_cargas_2022 b on
            a.no_liberacao = b.no_liberacao
    left join
        pimscs.funcionars c on
            a.cd_operador = c.cd_func
    where
        b.cd_unid_ind = 11 and
        a.cd_tp_recurso = 'FS'  
    ) e on
    b.cd_safra = e."Safra" and
    a.no_liberacao = e."No. Liberacao"    
where
    b.cd_unid_ind = 11 and
    a.cd_tp_recurso in ('CD','TT','CM','TD')

UNION ALL

select--dRecursos--Safra 2021
    distinct
    to_number(trim(b.cd_upnivel1)||trim(b.cd_upnivel2)||case when to_number(trim(b.cd_upnivel3)) < 10 then '0'||trim(b.cd_upnivel3) else trim(b.cd_upnivel3) end) as "Layer",
    b.cd_safra as "Safra",
    a.no_liberacao as "No. Liberacao",
    b.no_queima as "No. Ordem Corte",
    case
        when a.cd_tp_recurso = 'TT' then 'Trator Transbordo'
        when a.cd_tp_recurso = 'CD' then 'Colhedora'
        when a.cd_tp_recurso = 'CM' then 'Caminhao Rodotrem'
        when a.cd_tp_recurso = 'TD' then 'Caminhao Dedicado'
    end as "Tipo Equipto",
    to_number(substr(a.cd_equipto,3,6)) as "Equipto",
    substr(a.cd_operador,3,5) || '-' || c.de_func as "Operador",
    d."Noteiro" as "Noteiro",
    e."Lider" as "Lider"
from
    pimscs.apt_cargas_rec_2021 a
inner join
    pimscs.apt_cargas_2021 b on
        a.no_liberacao = b.no_liberacao
left join
    pimscs.funcionars c on
        a.cd_operador = c.cd_func
left join
    (
    select--dRecursos--Noteiro/Apontador
        distinct
        b.cd_safra as "Safra",
        a.no_liberacao as "No. Liberacao",
        substr(a.cd_operador,3,5) || '-' || c.de_func as "Noteiro"
    from
        pimscs.apt_cargas_rec_2021 a
    inner join
        pimscs.apt_cargas_2021 b on
            a.no_liberacao = b.no_liberacao
    left join
        pimscs.funcionars c on
            a.cd_operador = c.cd_func
    where
        b.cd_unid_ind = 11 and
        a.cd_tp_recurso = 'CO'    
    ) d on
    b.cd_safra = d."Safra" and
    a.no_liberacao = d."No. Liberacao"
left join
    (
    select--dRecursos--Lider
        distinct
        b.cd_safra as "Safra",
        a.no_liberacao as "No. Liberacao",
        substr(a.cd_operador,3,5) || '-' || c.de_func as "Lider"
    from
        pimscs.apt_cargas_rec_2021 a
    inner join
        pimscs.apt_cargas_2021 b on
            a.no_liberacao = b.no_liberacao
    left join
        pimscs.funcionars c on
            a.cd_operador = c.cd_func
    where
        b.cd_unid_ind = 11 and
        a.cd_tp_recurso = 'FS'  
    ) e on
    b.cd_safra = e."Safra" and
    a.no_liberacao = e."No. Liberacao"    
where
    b.cd_unid_ind = 11 and
    a.cd_tp_recurso in ('CD','TT','CM','TD')

UNION ALL

select--dRecursos--Safra 2020
    distinct
    to_number(trim(b.cd_upnivel1)||trim(b.cd_upnivel2)||case when to_number(trim(b.cd_upnivel3)) < 10 then '0'||trim(b.cd_upnivel3) else trim(b.cd_upnivel3) end) as "Layer",
    b.cd_safra as "Safra",
    a.no_liberacao as "No. Liberacao",
    b.no_queima as "No. Ordem Corte",
    case
        when a.cd_tp_recurso = 'TT' then 'Trator Transbordo'
        when a.cd_tp_recurso = 'CD' then 'Colhedora'
        when a.cd_tp_recurso = 'CM' then 'Caminhao Rodotrem'
        when a.cd_tp_recurso = 'TD' then 'Caminhao Dedicado'
    end as "Tipo Equipto",
    to_number(substr(a.cd_equipto,3,6)) as "Equipto",
    substr(a.cd_operador,3,5) || '-' || c.de_func as "Operador",
    d."Noteiro" as "Noteiro",
    e."Lider" as "Lider"
from
    pimscs.apt_cargas_rec_2020 a
inner join
    pimscs.apt_cargas_2020 b on
        a.no_liberacao = b.no_liberacao
left join
    pimscs.funcionars c on
        a.cd_operador = c.cd_func
left join
    (
    select--dRecursos--Noteiro/Apontador
        distinct
        b.cd_safra as "Safra",
        a.no_liberacao as "No. Liberacao",
       substr(a.cd_operador,3,5) || '-' || c.de_func as "Noteiro"
    from
        pimscs.apt_cargas_rec_2020 a
    inner join
        pimscs.apt_cargas_2020 b on
            a.no_liberacao = b.no_liberacao
    left join
        pimscs.funcionars c on
            a.cd_operador = c.cd_func
    where
        b.cd_unid_ind = 11 and
        a.cd_tp_recurso = 'CO'    
    ) d on
    b.cd_safra = d."Safra" and
    a.no_liberacao = d."No. Liberacao"
left join
    (
    select--dRecursos--Lider
        distinct
        b.cd_safra as "Safra",
        a.no_liberacao as "No. Liberacao",
        substr(a.cd_operador,3,5) || '-' || c.de_func as "Lider"
    from
        pimscs.apt_cargas_rec_2020 a
    inner join
        pimscs.apt_cargas_2020 b on
            a.no_liberacao = b.no_liberacao
    left join
        pimscs.funcionars c on
            a.cd_operador = c.cd_func
    where
        b.cd_unid_ind = 11 and
        a.cd_tp_recurso = 'FS'  
    ) e on
    b.cd_safra = e."Safra" and
    a.no_liberacao = e."No. Liberacao"    
where
    b.cd_unid_ind = 11 and
    a.cd_tp_recurso in ('CD','TT','CM','TD')
