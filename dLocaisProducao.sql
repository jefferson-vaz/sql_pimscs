/* Objetivo: Quando executada esta instrução, retorna uma Tabela de Resumo das Frentes de Colheita das Últimas 4 Safras do Histórico de Produção, Apt_Cargas e Perdas de Colheita Mecânica - Virada Safra Automatica  */

select--dLocaisProducao
    distinct
    to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) as "Layer",
    a.cd_safra as "Safra",
    a.cd_upnivel1 as "Mapa",
    a.cd_upnivel2 as "Gleba",
    a.cd_upnivel3 as "Quadra",
    b.de_upnivel1 as "Propriedade",
    case
        when to_number(a.cd_upnivel1) < 5000 then 'Parceiro'
        when to_number(a.cd_upnivel1) < 6000 then 'Fornecedor'
        when to_number(a.cd_upnivel1) >= 6000 then 'Compra Spot'
    end as "Participacao",
    c.de_fornec as "Proprietario",
    d.de_varied as "Variedade",
    e.de_maturac as "Ciclo Maturacao",
    g.da_ambiente_prod as "Amb. Producao",
    case
        when h.no_corte = 0 then h.de_estagio
        when h.no_corte = 1 then substr(h.de_estagio,12,3)
        else h.no_corte || 'C'
    end as "Estagio Corte",
    h.no_corte as "No. Corte",
    i.de_sist_cult as "Sist. Cultivo",
    j."Idade (Meses)" as "Idade (Meses)",
    case
        when f.fg_aplic_resliq = 'N' then 'Nao' 
        else 'Sim' 
    end as "Bacia Vinhaca"
from
    pimscs.histproduc a
left join
    pimscs.upnivel1 b on
        a.cd_upnivel1 = b.cd_upnivel1
left join
    pimscs.fornecs c on
        b.cd_fornec = c.cd_fornec
left join
    pimscs.variedades d on
        a.cd_varied = d.cd_varied
left join
    pimscs.tipo_maturac e on
        d.fg_maturac = e.fg_maturac
left join
    pimscs.upnivel3 f on
        a.cd_safra = f.cd_safra and
        a.cd_upnivel1 = f.cd_upnivel1 and
        a.cd_upnivel2 = f.cd_upnivel2 and
        a.cd_upnivel3 = f.cd_upnivel3
left join
    pimscs.ambienteprod g on
        f.cd_ambiente_prod = g.cd_ambiente_prod
left join
    pimscs.estagios h on
        f.cd_estagio = h.cd_estagio
left join
    pimscs.sistcultiv i on
        f.cd_sist_cult = i.cd_sist_cult
left join
    (
    select--Idades da Safra Atual
        a.layer as "Layer",
        (select max(cd_safra) from histprepro where cd_hist not in ('E','S')) as "Safra",
        a.cd_upnivel1 as "Mapa",
        a.cd_upnivel2 as "Gleba",
        a.cd_upnivel3 as "Quadra",
        a.data_fech as "Data de Fechamento",
        b.data as "Data do Último Corte",
        c.data as "Data do Corte Atual",
        case 
            when b.data is null then 0
            when a.data_fech is null then round(((to_date(sysdate,'dd/mm/yyyy') -  to_date(b.data,'dd/mm/yyyy')) / 30),1)
            else round(((a.data_fech -  to_date(b.data,'dd/mm/yyyy')) / 30),1)
        end as "Idade (Meses)"
    from
        (
        select--Cadastro
            to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) layer,
            a.cd_upnivel1,
            a.cd_upnivel2,
            a.cd_upnivel3,
            c.no_corte,
            case 
                when b.fg_ocorren = 'F' then to_date(b.dt_ocorren,'dd/mm/yyyy')
                else null
            end as data_fech
        from
            pimscs.upnivel3 a
        left join
            pimscs.safrupniv3 b on
             a.cd_upnivel1 = b.cd_upnivel1 and
             a.cd_upnivel2 = b.cd_upnivel2 and
             a.cd_upnivel3 = b.cd_upnivel3
        left join
            pimscs.estagios c on
            a.cd_estagio = c.cd_estagio
        where
            a.cd_safra = (select max(cd_safra) from histprepro where cd_hist not in ('E','S')) and
            b.cd_safra = (select max(cd_safra) from histprepro where cd_hist not in ('E','S')) and
            a.cd_ocup = 1 and
            b.fg_ocorren <> 'I' and
            b.dt_ocorren =
                (select
                    max(b2.dt_ocorren) 
                from
                    pimscs.safrupniv3 b2
                where
                     b.cd_upnivel1 = b2.cd_upnivel1 and
                     b.cd_upnivel2 = b2.cd_upnivel2 and
                     b.cd_upnivel3 = b2.cd_upnivel3 and
                     b2.cd_safra = (select max(cd_safra) from histprepro where cd_hist not in ('E','S'))
                )    
        ) a
        
    left join
    
        (
        select--Corte Anterior
            layer layer,
            max(data) data
        from
        (select--Ultima Q
           to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) layer,
            a.dt_ocorren data
        from 
            pimscs.safrupniv3 a
        where 
            a.dt_ocorren = (select 
                                max(a2.dt_ocorren) 
                            from 
                                pimscs.safrupniv3 a2
                            where 
                                    a.cd_upnivel1 = a2.cd_upnivel1
                                and a.cd_upnivel2 = a2.cd_upnivel2
                                and a.cd_upnivel3 = a2.cd_upnivel3
                                and a2.cd_safra between (select max(cd_safra)-2 from histprepro where cd_hist not in ('E','S')) and (select max(cd_safra)-1 from histprepro where cd_hist not in ('E','S'))
                                and a2.fg_ocorren = 'Q')
        union
        select--Ultima P
            to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) layer,
            a.dt_ocorren data
        from 
            pimscs.safrupniv3 a
        where 
            a.dt_ocorren = (select 
                                max(a2.dt_ocorren) 
                            from 
                                pimscs.safrupniv3 a2
                            where 
                                    a.cd_upnivel1 = a2.cd_upnivel1
                                and a.cd_upnivel2 = a2.cd_upnivel2
                                and a.cd_upnivel3 = a2.cd_upnivel3
                                and a2.cd_safra between (select max(cd_safra)-2 from histprepro where cd_hist not in ('E','S')) and (select max(cd_safra) from histprepro where cd_hist not in ('E','S'))
                                and a2.fg_ocorren = 'P')
        union
        select--Ultima N
            to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) layer,
            a.dt_ocorren data
        from 
            pimscs.safrupniv3 a
        where 
            a.dt_ocorren = (select 
                                max(a2.dt_ocorren) 
                            from 
                                pimscs.safrupniv3 a2
                            where 
                                    a.cd_upnivel1 = a2.cd_upnivel1
                                and a.cd_upnivel2 = a2.cd_upnivel2
                                and a.cd_upnivel3 = a2.cd_upnivel3
                                and a2.cd_safra between (select max(cd_safra)-2 from histprepro where cd_hist not in ('E','S')) and (select max(cd_safra) from histprepro where cd_hist not in ('E','S'))
                                and a2.fg_ocorren = 'N'))
        group by
            layer
        ) b on
        a.layer = b.layer
    left join
        (
        select--Corte Anterior
            layer layer,
            max(data) data
        from
        (select--Ultima Q
            to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) layer,
            a.dt_ocorren data
        from 
            pimscs.safrupniv3 a
        where 
            a.dt_ocorren = (select 
                                max(a2.dt_ocorren) 
                            from 
                                pimscs.safrupniv3 a2
                            where 
                                    a.cd_upnivel1 = a2.cd_upnivel1
                                and a.cd_upnivel2 = a2.cd_upnivel2
                                and a.cd_upnivel3 = a2.cd_upnivel3
                                and a2.cd_safra = (select max(cd_safra) from histprepro where cd_hist = 'O')
                                and a2.fg_ocorren = 'Q'
                            )
        union
        select--Ultima P
            to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) layer,
            a.dt_ocorren data
        from 
            pimscs.safrupniv3 a
        where 
            a.dt_ocorren = (select 
                                max(a2.dt_ocorren) 
                            from 
                                pimscs.safrupniv3 a2
                            where 
                                    a.cd_upnivel1 = a2.cd_upnivel1
                                and a.cd_upnivel2 = a2.cd_upnivel2
                                and a.cd_upnivel3 = a2.cd_upnivel3
                                and a2.cd_safra = (select max(cd_safra) from histprepro where cd_hist not in ('E','S'))
                                and a2.fg_ocorren = 'P'
                            )
        )
        group by
            layer  
        ) c on
        a.layer = c.layer
        
    UNION ALL
    
    select--Idades da Safra Atual-1
        a.layer as "Layer",
       (select max(cd_safra)-1 from histprepro where cd_hist not in ('E','S')) as "Safra",
        a.cd_upnivel1 as "Mapa",
        a.cd_upnivel2 as "Gleba",
        a.cd_upnivel3 as "Quadra",
        a.data_fech as "Data de Fechamento",
        b.data as "Data do Último Corte",
        c.data as "Data do Corte Atual",
        case 
            when b.data is null then 0
            when a.data_fech is null then round(((to_date(sysdate,'dd/mm/yyyy') -  to_date(b.data,'dd/mm/yyyy')) / 30),1)
            else round(((a.data_fech -  to_date(b.data,'dd/mm/yyyy')) / 30),1)
        end as "Idade (Meses)"
    from
        (
        select--Cadastro
            to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) layer,
            a.cd_upnivel1,
            a.cd_upnivel2,
            a.cd_upnivel3,
            c.no_corte,
            case 
                when b.fg_ocorren = 'F' then to_date(b.dt_ocorren,'dd/mm/yyyy')
                else null
            end as data_fech
        from
            pimscs.upnivel3 a
        left join
            pimscs.safrupniv3 b on
             a.cd_upnivel1 = b.cd_upnivel1 and
             a.cd_upnivel2 = b.cd_upnivel2 and
             a.cd_upnivel3 = b.cd_upnivel3
        left join
            pimscs.estagios c on
            a.cd_estagio = c.cd_estagio
        where
            a.cd_safra = (select max(cd_safra)-1 from histprepro where cd_hist not in ('E','S')) and
            b.cd_safra = (select max(cd_safra)-1 from histprepro where cd_hist not in ('E','S')) and
            a.cd_ocup = 1 and
            b.fg_ocorren <> 'I' and
            b.dt_ocorren =
                (select
                    max(b2.dt_ocorren) 
                from
                    pimscs.safrupniv3 b2
                where
                     b.cd_upnivel1 = b2.cd_upnivel1 and
                     b.cd_upnivel2 = b2.cd_upnivel2 and
                     b.cd_upnivel3 = b2.cd_upnivel3 and
                     b2.cd_safra = (select max(cd_safra)-1 from histprepro where cd_hist not in ('E','S'))
                )    
        ) a
        
    left join
    
        (
        select--Corte Anterior
            layer layer,
            max(data) data
        from
        (select--Ultima Q
           to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) layer,
            a.dt_ocorren data
        from 
            pimscs.safrupniv3 a
        where 
            a.dt_ocorren = (select 
                                max(a2.dt_ocorren) 
                            from 
                                pimscs.safrupniv3 a2
                            where 
                                    a.cd_upnivel1 = a2.cd_upnivel1
                                and a.cd_upnivel2 = a2.cd_upnivel2
                                and a.cd_upnivel3 = a2.cd_upnivel3
                                and a2.cd_safra between ((select max(cd_safra)-1 from histprepro where cd_hist not in ('E','S'))-2) and ((select max(cd_safra)-1 from histprepro where cd_hist not in ('E','S'))-1)
                                and a2.fg_ocorren = 'Q')
        union
        select--Ultima P
            to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) layer,
            a.dt_ocorren data
        from 
            pimscs.safrupniv3 a
        where 
            a.dt_ocorren = (select 
                                max(a2.dt_ocorren) 
                            from 
                                pimscs.safrupniv3 a2
                            where 
                                    a.cd_upnivel1 = a2.cd_upnivel1
                                and a.cd_upnivel2 = a2.cd_upnivel2
                                and a.cd_upnivel3 = a2.cd_upnivel3
                                and a2.cd_safra between ((select max(cd_safra)-1 from histprepro where cd_hist not in ('E','S'))-2) and ((select max(cd_safra)-1 from histprepro where cd_hist not in ('E','S')))
                                and a2.fg_ocorren = 'P')
        union
        select--Ultima N
            to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) layer,
            a.dt_ocorren data
        from 
            pimscs.safrupniv3 a
        where 
            a.dt_ocorren = (select 
                                max(a2.dt_ocorren) 
                            from 
                                pimscs.safrupniv3 a2
                            where 
                                    a.cd_upnivel1 = a2.cd_upnivel1
                                and a.cd_upnivel2 = a2.cd_upnivel2
                                and a.cd_upnivel3 = a2.cd_upnivel3
                                and a2.cd_safra between ((select max(cd_safra)-1 from histprepro where cd_hist not in ('E','S'))-2) and ((select max(cd_safra)-1 from histprepro where cd_hist not in ('E','S')))
                                and a2.fg_ocorren = 'N'))
        group by
            layer
        ) b on
        a.layer = b.layer
    left join
        (
        select--Corte Anterior
            layer layer,
            max(data) data
        from
        (select--Ultima Q
            to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) layer,
            a.dt_ocorren data
        from 
            pimscs.safrupniv3 a
        where 
            a.dt_ocorren = (select 
                                max(a2.dt_ocorren) 
                            from 
                                pimscs.safrupniv3 a2
                            where 
                                    a.cd_upnivel1 = a2.cd_upnivel1
                                and a.cd_upnivel2 = a2.cd_upnivel2
                                and a.cd_upnivel3 = a2.cd_upnivel3
                                and a2.cd_safra = (select max(cd_safra)-1 from histprepro where cd_hist not in ('E','S'))
                                and a2.fg_ocorren = 'Q'
                            )
        union
        select--Ultima P
            to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) layer,
            a.dt_ocorren data
        from 
            pimscs.safrupniv3 a
        where 
            a.dt_ocorren = (select 
                                max(a2.dt_ocorren) 
                            from 
                                pimscs.safrupniv3 a2
                            where 
                                    a.cd_upnivel1 = a2.cd_upnivel1
                                and a.cd_upnivel2 = a2.cd_upnivel2
                                and a.cd_upnivel3 = a2.cd_upnivel3
                                and a2.cd_safra = (select max(cd_safra)-1 from histprepro where cd_hist not in ('E','S'))
                                and a2.fg_ocorren = 'P'
                            )
        )
        group by
            layer  
        ) c on
        a.layer = c.layer
    
    UNION ALL
    
    select--Idades da Safra Atual-2
        a.layer as "Layer",
       (select max(cd_safra)-2 from histprepro where cd_hist not in ('E','S')) as "Safra",
        a.cd_upnivel1 as "Mapa",
        a.cd_upnivel2 as "Gleba",
        a.cd_upnivel3 as "Quadra",
        a.data_fech as "Data de Fechamento",
        b.data as "Data do Último Corte",
        c.data as "Data do Corte Atual",
        case 
            when b.data is null then 0
            when a.data_fech is null then round(((to_date(sysdate,'dd/mm/yyyy') -  to_date(b.data,'dd/mm/yyyy')) / 30),1)
            else round(((a.data_fech -  to_date(b.data,'dd/mm/yyyy')) / 30),1)
        end as "Idade (Meses)"
    from
        (
        select--Cadastro
            to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) layer,
            a.cd_upnivel1,
            a.cd_upnivel2,
            a.cd_upnivel3,
            c.no_corte,
            case 
                when b.fg_ocorren = 'F' then to_date(b.dt_ocorren,'dd/mm/yyyy')
                else null
            end as data_fech
        from
            pimscs.upnivel3 a
        left join
            pimscs.safrupniv3 b on
             a.cd_upnivel1 = b.cd_upnivel1 and
             a.cd_upnivel2 = b.cd_upnivel2 and
             a.cd_upnivel3 = b.cd_upnivel3
        left join
            pimscs.estagios c on
            a.cd_estagio = c.cd_estagio
        where
            a.cd_safra = (select max(cd_safra)-2 from histprepro where cd_hist not in ('E','S')) and
            b.cd_safra = (select max(cd_safra)-2 from histprepro where cd_hist not in ('E','S')) and
            a.cd_ocup = 1 and
            b.fg_ocorren <> 'I' and
            b.dt_ocorren =
                (select
                    max(b2.dt_ocorren) 
                from
                    pimscs.safrupniv3 b2
                where
                     b.cd_upnivel1 = b2.cd_upnivel1 and
                     b.cd_upnivel2 = b2.cd_upnivel2 and
                     b.cd_upnivel3 = b2.cd_upnivel3 and
                     b2.cd_safra = (select max(cd_safra)-2 from histprepro where cd_hist not in ('E','S'))
                )    
        ) a
        
    left join
    
        (
        select--Corte Anterior
            layer layer,
            max(data) data
        from
        (select--Ultima Q
           to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) layer,
            a.dt_ocorren data
        from 
            pimscs.safrupniv3 a
        where 
            a.dt_ocorren = (select 
                                max(a2.dt_ocorren) 
                            from 
                                pimscs.safrupniv3 a2
                            where 
                                    a.cd_upnivel1 = a2.cd_upnivel1
                                and a.cd_upnivel2 = a2.cd_upnivel2
                                and a.cd_upnivel3 = a2.cd_upnivel3
                                and a2.cd_safra between ((select max(cd_safra)-2 from histprepro where cd_hist not in ('E','S'))-2) and ((select max(cd_safra)-2 from histprepro where cd_hist not in ('E','S'))-1)
                                and a2.fg_ocorren = 'Q')
        union
        select--Ultima P
            to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) layer,
            a.dt_ocorren data
        from 
            pimscs.safrupniv3 a
        where 
            a.dt_ocorren = (select 
                                max(a2.dt_ocorren) 
                            from 
                                pimscs.safrupniv3 a2
                            where 
                                    a.cd_upnivel1 = a2.cd_upnivel1
                                and a.cd_upnivel2 = a2.cd_upnivel2
                                and a.cd_upnivel3 = a2.cd_upnivel3
                                and a2.cd_safra between ((select max(cd_safra)-2 from histprepro where cd_hist not in ('E','S'))-2) and ((select max(cd_safra)-2 from histprepro where cd_hist not in ('E','S')))
                                and a2.fg_ocorren = 'P')
        union
        select--Ultima N
            to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) layer,
            a.dt_ocorren data
        from 
            pimscs.safrupniv3 a
        where 
            a.dt_ocorren = (select 
                                max(a2.dt_ocorren) 
                            from 
                                pimscs.safrupniv3 a2
                            where 
                                    a.cd_upnivel1 = a2.cd_upnivel1
                                and a.cd_upnivel2 = a2.cd_upnivel2
                                and a.cd_upnivel3 = a2.cd_upnivel3
                                and a2.cd_safra between ((select max(cd_safra)-2 from histprepro where cd_hist not in ('E','S'))-2) and ((select max(cd_safra)-2 from histprepro where cd_hist not in ('E','S')))
                                and a2.fg_ocorren = 'N'))
        group by
            layer
        ) b on
        a.layer = b.layer
    left join
        (
        select--Corte Anterior
            layer layer,
            max(data) data
        from
        (select--Ultima Q
            to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) layer,
            a.dt_ocorren data
        from 
            pimscs.safrupniv3 a
        where 
            a.dt_ocorren = (select 
                                max(a2.dt_ocorren) 
                            from 
                                pimscs.safrupniv3 a2
                            where 
                                    a.cd_upnivel1 = a2.cd_upnivel1
                                and a.cd_upnivel2 = a2.cd_upnivel2
                                and a.cd_upnivel3 = a2.cd_upnivel3
                                and a2.cd_safra = (select max(cd_safra)-2 from histprepro where cd_hist not in ('E','S'))
                                and a2.fg_ocorren = 'Q'
                            )
        union
        select--Ultima P
            to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) layer,
            a.dt_ocorren data
        from 
            pimscs.safrupniv3 a
        where 
            a.dt_ocorren = (select 
                                max(a2.dt_ocorren) 
                            from 
                                pimscs.safrupniv3 a2
                            where 
                                    a.cd_upnivel1 = a2.cd_upnivel1
                                and a.cd_upnivel2 = a2.cd_upnivel2
                                and a.cd_upnivel3 = a2.cd_upnivel3
                                and a2.cd_safra = (select max(cd_safra)-2 from histprepro where cd_hist not in ('E','S'))
                                and a2.fg_ocorren = 'P'
                            )
        )
        group by
            layer  
        ) c on
        a.layer = c.layer
    
    UNION ALL
    
    select--Idades da Safra Atual-3
        a.layer as "Layer",
       (select max(cd_safra)-3 from histprepro where cd_hist not in ('E','S')) as "Safra",
        a.cd_upnivel1 as "Mapa",
        a.cd_upnivel2 as "Gleba",
        a.cd_upnivel3 as "Quadra",
        a.data_fech as "Data de Fechamento",
        b.data as "Data do Último Corte",
        c.data as "Data do Corte Atual",
        case 
            when b.data is null then 0
            when a.data_fech is null then round(((to_date(sysdate,'dd/mm/yyyy') -  to_date(b.data,'dd/mm/yyyy')) / 30),1)
            else round(((a.data_fech -  to_date(b.data,'dd/mm/yyyy')) / 30),1)
        end as "Idade (Meses)"
    from
        (
        select--Cadastro
            to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) layer,
            a.cd_upnivel1,
            a.cd_upnivel2,
            a.cd_upnivel3,
            c.no_corte,
            case 
                when b.fg_ocorren = 'F' then to_date(b.dt_ocorren,'dd/mm/yyyy')
                else null
            end as data_fech
        from
            pimscs.upnivel3 a
        left join
            pimscs.safrupniv3 b on
             a.cd_upnivel1 = b.cd_upnivel1 and
             a.cd_upnivel2 = b.cd_upnivel2 and
             a.cd_upnivel3 = b.cd_upnivel3
        left join
            pimscs.estagios c on
            a.cd_estagio = c.cd_estagio
        where
            a.cd_safra = (select max(cd_safra)-3 from histprepro where cd_hist not in ('E','S')) and
            b.cd_safra = (select max(cd_safra)-3 from histprepro where cd_hist not in ('E','S')) and
            a.cd_ocup = 1 and
            b.fg_ocorren <> 'I' and
            b.dt_ocorren =
                (select
                    max(b2.dt_ocorren) 
                from
                    pimscs.safrupniv3 b2
                where
                     b.cd_upnivel1 = b2.cd_upnivel1 and
                     b.cd_upnivel2 = b2.cd_upnivel2 and
                     b.cd_upnivel3 = b2.cd_upnivel3 and
                     b2.cd_safra = (select max(cd_safra)-3 from histprepro where cd_hist not in ('E','S'))
                )    
        ) a
        
    left join
    
        (
        select--Corte Anterior
            layer layer,
            max(data) data
        from
        (select--Ultima Q
           to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) layer,
            a.dt_ocorren data
        from 
            pimscs.safrupniv3 a
        where 
            a.dt_ocorren = (select 
                                max(a2.dt_ocorren) 
                            from 
                                pimscs.safrupniv3 a2
                            where 
                                    a.cd_upnivel1 = a2.cd_upnivel1
                                and a.cd_upnivel2 = a2.cd_upnivel2
                                and a.cd_upnivel3 = a2.cd_upnivel3
                                and a2.cd_safra between ((select max(cd_safra)-3 from histprepro where cd_hist not in ('E','S'))-2) and ((select max(cd_safra)-3 from histprepro where cd_hist not in ('E','S'))-1)
                                and a2.fg_ocorren = 'Q')
        union
        select--Ultima P
            to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) layer,
            a.dt_ocorren data
        from 
            pimscs.safrupniv3 a
        where 
            a.dt_ocorren = (select 
                                max(a2.dt_ocorren) 
                            from 
                                pimscs.safrupniv3 a2
                            where 
                                    a.cd_upnivel1 = a2.cd_upnivel1
                                and a.cd_upnivel2 = a2.cd_upnivel2
                                and a.cd_upnivel3 = a2.cd_upnivel3
                                and a2.cd_safra between ((select max(cd_safra)-3 from histprepro where cd_hist not in ('E','S'))-2) and ((select max(cd_safra)-3 from histprepro where cd_hist not in ('E','S')))
                                and a2.fg_ocorren = 'P')
        union
        select--Ultima N
            to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) layer,
            a.dt_ocorren data
        from 
            pimscs.safrupniv3 a
        where 
            a.dt_ocorren = (select 
                                max(a2.dt_ocorren) 
                            from 
                                pimscs.safrupniv3 a2
                            where 
                                    a.cd_upnivel1 = a2.cd_upnivel1
                                and a.cd_upnivel2 = a2.cd_upnivel2
                                and a.cd_upnivel3 = a2.cd_upnivel3
                                and a2.cd_safra between ((select max(cd_safra)-3 from histprepro where cd_hist not in ('E','S'))-2) and ((select max(cd_safra)-3 from histprepro where cd_hist not in ('E','S')))
                                and a2.fg_ocorren = 'N'))
        group by
            layer
        ) b on
        a.layer = b.layer
    left join
        (
        select--Corte Anterior
            layer layer,
            max(data) data
        from
        (select--Ultima Q
            to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) layer,
            a.dt_ocorren data
        from 
            pimscs.safrupniv3 a
        where 
            a.dt_ocorren = (select 
                                max(a2.dt_ocorren) 
                            from 
                                pimscs.safrupniv3 a2
                            where 
                                    a.cd_upnivel1 = a2.cd_upnivel1
                                and a.cd_upnivel2 = a2.cd_upnivel2
                                and a.cd_upnivel3 = a2.cd_upnivel3
                                and a2.cd_safra = (select max(cd_safra)-3 from histprepro where cd_hist not in ('E','S'))
                                and a2.fg_ocorren = 'Q'
                            )
        union
        select--Ultima P
            to_number(trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end) layer,
            a.dt_ocorren data
        from 
            pimscs.safrupniv3 a
        where 
            a.dt_ocorren = (select 
                                max(a2.dt_ocorren) 
                            from 
                                pimscs.safrupniv3 a2
                            where 
                                    a.cd_upnivel1 = a2.cd_upnivel1
                                and a.cd_upnivel2 = a2.cd_upnivel2
                                and a.cd_upnivel3 = a2.cd_upnivel3
                                and a2.cd_safra = (select max(cd_safra)-3 from histprepro where cd_hist not in ('E','S'))
                                and a2.fg_ocorren = 'P'
                            )
        )
        group by
            layer  
        ) c on
        a.layer = c.layer
    ) j on
        a.cd_safra = j."Safra" and
        a.cd_upnivel1 = j."Mapa" and
        a.cd_upnivel2 = j."Gleba" and
        a.cd_upnivel3 = j."Quadra"       
where
    a.cd_safra >=
        (
            select
                max(cd_safra)-3
            from
                pimscs.histproduc
    )
--order by 1
