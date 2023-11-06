/* Objetivo: Quando executada esta instrução, retorna uma Tabela com Produção do Histórico da Entrada de Cana das Ultimas 3 Safras + Safra Atual - Virada Safra Automatica  */

select--Histórico de Entrada de Cana
    to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) as "Layer",
    a.cd_safra as "Safra",
    a.cd_upnivel1 as "Mapa",
    a.cd_upnivel2 as "Gleba",
    a.cd_upnivel3 as "Quadra",
    a.dt_historico as "Data",
    e."No. Corte" as "No. Corte",
    a.cd_fren_tran as "Frente",
    sum(a.qt_cana_ent/1000) as "Toneladas de Cana",    
    sum((a.qt_idade/30.2) * (a.qt_cana_ent/1000)) as "ponderar_idade",
    sum (( a.ds_terra + a.ds_asfalto ) * a.qt_cana_ent) / 1000 as "ponderar_distancia",    
    sum(decode(a.kg_brix,0,0,a.kg_brix)) as "kg_brix",
    sum(decode(a.kg_brix,0,0,a.qt_cana_ent)) as "ton_brix",
    sum(decode(a.kg_pex,0,0,a.kg_pex)) as "kg_pol",
    sum(decode(a.kg_pex,0,0,a.qt_cana_ent)) as "ton_pol",  
    sum(decode(a.kg_fibra,0,0,a.kg_fibra)) as "kg_fibra",
    sum(decode(a.kg_fibra,0,0,a.qt_cana_ent)) as "ton_fibra",
    sum (decode (a.qt_impur_veg,0,0,a.qt_impur_veg)) as "kg_imp_veg",    
    sum (decode (a.qt_impur_veg,0,0,a.qt_cana_ent)) as "ton_imp_veg",
    sum (decode (a.qt_impur_terra,0,0,a.qt_impur_terra)) as "kg_imp_min",    
    sum (decode (a.qt_impur_terra,0,0,a.qt_cana_ent)) as "ton_imp_min"
from 
    pimscs.histproduc a 
inner join
    pimscs.upnivel1 b on
        a.cd_upnivel1 = b.cd_upnivel1
inner join
    pimscs.variedades c on
        a.cd_varied = c.cd_varied
inner join
    pimscs.tipo_maturac d on
        c.fg_maturac = d.fg_maturac
left join
        (
        select--Cadastro de Estágios Interpretado
            a.*,
            decode(
                "Estagio",
                'Inverno','12M-Inv',
                'Ano','12M',
                'Ano e meio', '18M',
                'Ano e Meio', '18M',        
                '2º Corte','2C',
                '3º Corte','3C',        
                '4º Corte','4C',        
                '5º Corte','5C',        
                '>5º Corte','5C+',        
                'Pousio','Pous',
                'Expansao','Exp',
                'Reforma','Ref',
                "Estagio"        
            ) as "Est. Abrev."     
        from
                (
                select--Cadastro Estagios
                    cd_estagio as "Cod. Estagio",
                    case
                        when cd_estagio in (0,1,2,3,4,5) then de_estagio
                        else cd_equival_ctc
                    end as "Estagio",
                    no_corte as "No. Corte"
                from
                    pimscs.estagios
            ) a        
    ) e on
        a.cd_estagio = e."Cod. Estagio"
inner join
    pimscs.upnivel3 f on
        a.cd_safra = f.cd_safra and
        a.cd_upnivel1 = f.cd_upnivel1 and
        a.cd_upnivel2 = f.cd_upnivel2 and
        a.cd_upnivel3 = f.cd_upnivel3 
left join
    pimscs.sistcultiv g on
        f.cd_sist_cult = g.cd_sist_cult
left join
    pimscs.ambienteprod h on
        f.cd_ambiente_prod = h.cd_ambiente_prod
left join
    pimscs.sistdrenag i on
        f.cd_sist_dren = i.cd_sist_dren
left join
    pimscs.safrupniv3 j on
        a.cd_safra = j.cd_safra and
        a.cd_upnivel1 = j.cd_upnivel1 and
        a.cd_upnivel2 = j.cd_upnivel2 and
        a.cd_upnivel3 = j.cd_upnivel3 
where
    a.cd_safra >= 
        (
            select
                max(cd_safra)-3
            from
                pimscs.histproduc
    ) and
    j.dt_ocorren = 
        (
            select
                max(j2.dt_ocorren)
            from
                pimscs.safrupniv3 j2
            where
                j.cd_safra = j2.cd_safra and
                j.cd_upnivel1 = j2.cd_upnivel1 and
                j.cd_upnivel2 = j2.cd_upnivel2 and
                j.cd_upnivel3 = j2.cd_upnivel3
    ) 
group by 
    to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end), 
    a.cd_safra, 
    a.cd_upnivel1,  
    a.cd_upnivel2, 
    a.cd_upnivel3, 
    a.dt_historico, 
    e."No. Corte", 
    a.cd_fren_tran