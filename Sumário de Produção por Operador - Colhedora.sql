/* Objetivo: Quando executada esta instrução, Retorna Tabela com informações do Operador Inserido no Filtro... (Aqui está pegando de uma tabela de Back_up do Apt_Cargas) */

select--Safra 2022
    b.cd_safra as "Safra",
    b.dt_movimento as "Data",
    a.cd_operador || '-' || c.de_func as "Operador",
    to_number(substr(a.cd_equipto,5,4)) as "Colhedora",
--    count(a.no_liberacao) as "Viagens",
    sum(a.qt_liquido/1000) as "Toneladas de Cana"
from
   pimscs.apt_cargas_rec_2022 a
inner join
    pimscs.apt_cargas_2022 b on
        a.no_liberacao = b.no_liberacao
left join
    pimscs.funcionars c on
        a.cd_operador = c.cd_func
where
    a.cd_tp_recurso = 'CD' and
    a.cd_operador like ('%05099%') 
group by 
    b.cd_safra, 
    b.dt_movimento, 
    a.cd_operador || '-' || c.de_func, 
    to_number(substr(a.cd_equipto,5,4))
