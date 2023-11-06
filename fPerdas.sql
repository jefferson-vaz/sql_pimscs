/* Objetivo: Quando executada esta instrução, retorna uma Tabela com as Perdas de Colheita Mecânica da Entrada de Cana das Ultimas 3 Safras + Safra Atual - Virada Safra Automatica  */

select--Perdas de Colheita Mecânica
    trim(d.cd_upnivel1)||trim(d.cd_upnivel2)||case when to_number(trim(d.cd_upnivel3)) < 10 then '0'||trim(d.cd_upnivel3) else trim(d.cd_upnivel3) end as "Layer",
    d.no_boletim as "Boletim",
    d.cd_safra as "Safra",
    d.cd_upnivel1 as "Fazenda",
    d.cd_upnivel2 as "Gleba",
    d.cd_upnivel3 as "Quadra",
    h.cd_fren_tran as "Frente",
    substr(d.cd_recurso,3,6) as "Equipto",
    h.dt_operacao as "Data",
    case 
        when h.cd_turno in (0,4) then '1'
        else h.cd_turno
    end as "Turno",
    d.no_amostra as "No. Amostra",
    round(d.qt_perda1/1000,2) as "Toco",
    round(d.qt_perda2/1000,2) as "Tolete",  
    round(d.qt_perda3/1000,2) as "Tolete Estilhacado",
    round(d.qt_perda4/1000,2) as "Pedaco Solto",
    round(d.qt_perda5/1000,2) as "Pedaco Fixo",
    round(d.qt_perda6/1000,2) as "Cana Inteira",
    round(d.qt_perda7/1000,2) as "Ponta",
    round(d.qt_perda8/1000,2) as "Estilhaco",
    d.qt_perda9 as "Arranquio Rizomas"
from 
    pimscs.apt_perda_de d
inner join
    pimscs.apt_perda_he h on
        h.instancia = d.instancia and 
        h.no_boletim = d.no_boletim and 
        h.fg_manmec = d.fg_manmec
left join
    pimscs.upnivel1 up1 on
        d.cd_upnivel1 = up1.cd_upnivel1
left join
    pimscs.fornecs f on
        up1.cd_fornec = f.cd_fornec
left join
    pimscs.upnivel3 up3 on
        d.cd_safra = up3.cd_safra and
        d.cd_upnivel1 = up3.cd_upnivel1 and
        d.cd_upnivel2 = up3.cd_upnivel2 and
        d.cd_upnivel3 = up3.cd_upnivel3 
left join
    pimscs.variedades var on
        up3.cd_varied = var.cd_varied
left join
    pimscs.ambienteprod amb on
        up3.cd_ambiente_prod = amb.cd_ambiente_prod
left join
    pimscs.moduloadm mod on
        up3.cd_mod_adm = mod.cd_mod_adm
left join
    pimscs.sistcultiv cultiv on
        up3.cd_sist_cult = cultiv.cd_sist_cult
left join
    (
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
                    'Passagem - Ref','PRef',
                    'Passagem - Exp','PExp',
                    "Estagio"        
                ) as estagio    
            from
                    (
                    select--Cadastro Estagios
                        cd_estagio,
                        case
                            when cd_estagio in (0,1,2,3,4,5,6) then de_estagio
                            else cd_equival_ctc
                        end as "Estagio",
                        no_corte as no_corte
                    from
                        pimscs.estagios
                ) a 
            )
    ) est on
        up3.cd_estagio = est.cd_estagio
left join
    pimscs.tipo_maturac tmat on
        var.fg_maturac = tmat.fg_maturac
where 
    h.fg_manmec = 2 and
    h.instancia = 'BV' and
    h.dt_operacao >= 
        (
            select 
                min(dt_historico) 
            from 
                pimscs.histproduc 
            where 
                cd_safra >=
                    (
                        select 
                            max(cd_safra)-3
                        from 
                            pimscs.histproduc
                )
            ) and
        d.cd_safra >= 
            (
                select 
                    max(cd_safra)-3
                from 
                    pimscs.histproduc
        )