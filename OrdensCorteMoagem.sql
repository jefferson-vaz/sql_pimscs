with--Sempre Busca a Ultima Safra -- Caso houver Objetivo de Safra Mas não houver Ordens para a Ultima Safra do Objetivo de Safra, o retorno sera Nulo.
    Ordem as(
        select
            trim(b.cd_upnivel1)||trim(b.cd_upnivel2)||case when to_number(trim(b.cd_upnivel3)) < 10 then '0'||trim(b.cd_upnivel3) else trim(b.cd_upnivel3) end as "Chave",
            b.cd_safra as "Safra",
            a.no_queima as "Ordem de Corte",
            'UBV' as "Empresa",
            a.cd_fren_tran as "No. Frente de Colheita",
            'Frente '|| a.cd_fren_tran as "Frente de Colheita",
            case
                when a.cd_fren_tran = 12 then 'Marco Tulio(C. Terceiros)'
                when a.cd_fren_tran = 9 then 'Experimento'
                else 'Danilo(Colheita)'
            end as "Responsavel Atual",
            b.cd_upnivel1 as "Mapa",
            b.cd_upnivel1|| ' (' || i.de_upnivel1|| ')' as "Fazenda",
            b.cd_upnivel2 as "Gleba",
            b.cd_upnivel3 as "Quadra",
            g."Est. Abrev." as "Estagio de Corte",
            g."No. Corte" as "No. de Corte",
            h.de_varied as "Variedade",
            k.de_maturac as "Ciclo Maturacao",
            n.da_ambiente_prod as "Amb. Producao",
            case
                when o.da_mod_adm = 'BOAVIS' then 'Boa Vista'
                when o.da_mod_adm = 'CACHOE' then 'Cachoeirinha'
                when o.da_mod_adm = 'CASTEL' then 'Castelo'
                when o.da_mod_adm = 'JACARE' then 'Jacare'
                when o.da_mod_adm = 'SANITA' then 'Sanita'
                when o.da_mod_adm = 'P.LISA' then 'Pedra Lisa'
                when o.da_mod_adm = 'QUIRI' then 'Quirinopolis'
            end as "Setor",
            case
                when f.fg_aplic_resliq = 'N' then 'Nao' 
                else 'Sim' 
            end as "Bacia",
            c.da_sist_colh as "Sistema de Colheita",
            m.de_sist_cult as "Sistema Cultivo",
            case 
                when a.fg_cana_crua = 'S' then 'Sim'
                else 'Não'
            end as "Cana Crua?",
            round(b.qt_area,2) as "Area (ha)",
            round((b.qt_estim/a.qt_estim_tot),5) as "% Toneladas",
            case
                when a.fg_situacao = 'F' then 'Fechada'
                else 'Aberta'
            end as "Situacao da Ordem",
            to_char(a.dt_queima,'dd/mm/yyyy') as "Data de Abertura",       
            to_char(a.dt_fechamento,'dd/mm/yyyy') as "Data de Fechamento", 
            to_char(a.hr_queima,'dd/mm/yyyy hh:mm') as "Hora da Abertura",
            to_char(a.dt_fechamento, 'dd/mm/yyyy hh:mm') as "Hora do Fechamento"
        from
            pimscs.queima_he a
        inner join
            pimscs.queima_de b on
             a.no_queima = b.no_queima
        left join
            pimscs.sistcolh c on
             a.cd_sist_colh = c.cd_sist_colh
        left join
            pimscs.frentransp d on
             a.cd_fren_tran = d.cd_fren_tran
        left join
            pimscs.upnivel3 f on
             b.cd_safra = f.cd_safra and
             b.cd_upnivel1 = f.cd_upnivel1 and
             b.cd_upnivel2 = f.cd_upnivel2 and             
             b.cd_upnivel3 = f.cd_upnivel3
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
                    'Passagem - Ref','PRef',
                    'Passagem - Exp','PExp',
                    "Estagio"        
                ) as "Est. Abrev."     
            from
                    (
                    select--Cadastro Estagios
                        cd_estagio as "Cod. Estagio",
                        case
                            when cd_estagio in (0,1,2,3,4,5,6) then de_estagio
                            else cd_equival_ctc
                        end as "Estagio",
                        no_corte as "No. Corte"
                    from
                        pimscs.estagios
                    where
                        cd_estagio <> 9
                ) a          
        ) g on
             f.cd_estagio = g."Cod. Estagio"
        left join
            pimscs.variedades h on
             f.cd_varied = h.cd_varied
        left join
            pimscs.tipo_maturac k on
                h.fg_maturac = k.fg_maturac
        left join
            pimscs.ambienteprod n on
                f.cd_ambiente_prod = n.cd_ambiente_prod
        left join
            pimscs.upnivel1 i on
                b.cd_upnivel1 = i.cd_upnivel1
        left join
            pimscs.moduloadm o on
                f.cd_mod_adm = o.cd_mod_adm
        left join
            pimscs.sistcultiv m on
                f.cd_sist_cult = m.cd_sist_cult
        where
            b.cd_safra = 
                (   
                    select
                        max(cd_safra)
                    from
                        pimscs.histprepro
                    where
                        cd_hist not in ('E','S')
            )
        ),
    Estimativa as (
        select
            trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end as "Chave",
            a.cd_upnivel1 as "Mapa",
            a.cd_upnivel2 as "Gleba",
            a.cd_upnivel1 as "Quadra",
            ((a.qt_cana_entr / 1000)/(a.qt_area_prod * 1)) as "TCH"
        from 
            pimscs.histprepro a
        where
            a.cd_safra = 
                (
                    select 
                        max(cd_safra) 
                    from 
                        pimscs.histprepro 
                    where 
                        cd_hist not in ('E','S')
            ) and
            a.cd_hist not in ('E','S') and
            a.dt_historico = 
                (
                    select
                        max(a2.dt_historico)
                    from
                        pimscs.histprepro a2
                    where
                        a.cd_safra = a2.cd_safra and
                        a.cd_upnivel1 = a2.cd_upnivel1 and
                        a.cd_upnivel2 = a2.cd_upnivel2 and
                        a.cd_upnivel3 = a2.cd_upnivel3 and
                        a2.cd_hist not in ('E','S')
            ) and
            a.qt_area_prod > 0        
    ),
    EntradaCana as (
        select
            a.no_queima as "Ordem de Corte",
            trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end as "Chave",
            max(dt_saida) data,
            max(hr_saida) as ultima_pesagem,
            sum(qt_liquido)/1000 toneladas
        from
            pimscs.apt_cargas a
        where
            a.cd_safra = 
                (   
                    select
                        max(cd_safra)
                    from
                        pimscs.histprepro
                    where
                        cd_hist not in ('E','S')
            )
        group by 
            trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end, 
            a.no_queima
    )
    
    select
        a.*,
        case 
            when a."Data de Fechamento" is null then round((sysdate - to_date(a."Data de Abertura",'dd/mm/yyyy')),0)
            else round((to_date(a."Data de Fechamento",'dd/mm/yyyy') - to_date(a."Data de Abertura",'dd/mm/yyyy')),0)
        end as "Dias Aberta",
        b.tch * a."Area (ha)" as "Toneladas Estimadas",
        case 
            when c.toneladas is null then 0 
            else round(c.toneladas,3)
        end as "Toneladas Realizadas",
        c.data as "Data da Ultima Pesagem",
        c.ultima_pesagem as "Ultima Pesagem",
        d."Data do Ultimo Corte",
        d."Idade (Meses)",
        case 
            when e."Etiquetas de Liberacao" is null then 'Não Impressa!'
            else e."Etiquetas de Liberacao"
        end as "Etiquetas de Liberacao",
        f."Ocorrencia Cadastro" as "Ult. Ocorr. Cad.",
        f."Data da Ocorrencia"
    from
        Ordem a
    left join
        Estimativa b on
         a."Chave" = b."Chave"
    left join
        EntradaCana c on
         a."Chave" = c."Chave" and
         a."Ordem de Corte" = c."Ordem de Corte"
    left join
        (with--Datas de Corte e Idade
        cadastro as(
            select--Cadastro de Talhões 
                trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(b.cd_upnivel3)) < 10 then '0'||trim(b.cd_upnivel3) else trim(b.cd_upnivel3) end Chave,
                c.no_corte,
                case 
                    when b.fg_ocorren = 'F' then to_date(b.dt_ocorren,'dd/mm/yyyy')
                    else null
                end as data_fech
            from
                pimscs.upnivel3 a
            left join
                pimscs.safrupniv3 b on
                 a.cd_safra = b.cd_safra and
                 a.cd_upnivel1 = b.cd_upnivel1 and
                 a.cd_upnivel2 = b.cd_upnivel2 and                 
                 a.cd_upnivel3 = b.cd_upnivel3
            left join
                pimscs.estagios c on
                a.cd_estagio = c.cd_estagio
            where
                a.cd_safra = 
                    (   
                        select
                            max(cd_safra)
                        from
                            pimscs.histprepro
                        where
                            cd_hist not in ('E','S')
                ) and
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
                         b2.cd_safra =
                            (   
                                select
                                    max(cd_safra)
                                from
                                    pimscs.histprepro
                                where
                                    cd_hist not in ('E','S')
                        )                       
                    )
        ),
        
        corte_anterior as(
            (select--Corte Anterior
                Chave Chave,
                max(data) data
            from
            (select--Ultima Q
                trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end Chave,
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
                                    and a2.cd_safra between --2020 and 2021
                                             (   
                                            select
                                                max(cd_safra)-2
                                            from
                                                pimscs.histprepro
                                            where
                                                cd_hist not in ('E','S')                                            
                                        ) and
                                            (   
                                            select
                                                max(cd_safra)-1
                                            from
                                                pimscs.histprepro
                                            where
                                                cd_hist not in ('E','S')                                                
                                        )                                   
                                    and a2.fg_ocorren = 'Q')
            union
            select--Ultima P
                trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end Chave,
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
                                    and a2.cd_safra between
                                                    (   
                                                    select
                                                        max(cd_safra)-2
                                                    from
                                                        pimscs.histprepro
                                                     where
                                                        cd_hist not in ('E','S')                                                   
                                                ) and
                                                    (   
                                                    select
                                                        max(cd_safra)
                                                    from
                                                        pimscs.histprepro
                                                     where
                                                        cd_hist not in ('E','S')                                                       
                                                )                                    
                                    and a2.fg_ocorren = 'P')
            union
            select--Ultima N
                trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end Chave,
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
                                    and a2.cd_safra between
                                                    (   
                                                    select
                                                        max(cd_safra)-2
                                                    from
                                                        pimscs.histprepro
                                                     where
                                                        cd_hist not in ('E','S')                                                       
                                                ) and
                                                    (   
                                                    select
                                                        max(cd_safra)
                                                    from
                                                        pimscs.histprepro
                                                     where
                                                        cd_hist not in ('E','S')                                                   
                                                )                                                 
                                    and a2.fg_ocorren = 'N'))
            group by
                Chave)
        ),
        
        corte_atual as (
            (select--Corte Atual
                Chave,
                max(data) data
            from
                (select--Ultima Q
                    trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end Chave,
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
                                        and a2.cd_safra =
                                            (   
                                                select
                                                    max(cd_safra)
                                                from
                                                    pimscs.histprepro
                                                where
                                                    cd_hist not in ('E','S')                                                    
                                        )
                                        and a2.fg_ocorren = 'Q'
                                     )
                )
            group by
                Chave
            )
        )
        
        select
            a.Chave as "Chave",
            a.data_fech as "Data de Fechamento",
            b.data as "Data do Ultimo Corte",
            c.data as "Data do Corte Atual",
            case 
                when b.data is null then 0
                when a.data_fech is null then round(((to_date(sysdate,'dd/mm/yyyy') -  to_date(b.data,'dd/mm/yyyy')) / 30),1)
                else round(((a.data_fech -  to_date(b.data,'dd/mm/yyyy')) / 30),1)
            end as "Idade (Meses)"
        from
            cadastro a
        left join
            corte_anterior b on
            a.Chave = b.Chave
        left join
            corte_atual c on
            a.Chave = c.Chave
        order by
            "Chave") d on
      a."Chave" = d."Chave"
    left join
        (with
        Utilizadas as (
            select
                no_queima ordem_corte,
                trim(cd_upnivel1)||trim(cd_upnivel2)||case when to_number(trim(cd_upnivel3)) < 10 then '0'||trim(cd_upnivel3) else trim(cd_upnivel3) end Chave,
                count(no_liberacao) qtde
            from 
                pimscs.liberacao
            where 
                 cd_safra = 
                    (   
                        select
                            max(cd_safra)
                        from
                            pimscs.histprepro
                         where
                            cd_hist not in ('E','S')                           
                ) and
                 fg_status = 'U'
            group by 
                no_queima, 
                trim(cd_upnivel1)||trim(cd_upnivel2)||case when to_number(trim(cd_upnivel3)) < 10 then '0'||trim(cd_upnivel3) else trim(cd_upnivel3) end
        ),
        Disponiveis as (
            select
                no_queima ordem_corte,
                trim(cd_upnivel1)||trim(cd_upnivel2)||case when to_number(trim(cd_upnivel3)) < 10 then '0'||trim(cd_upnivel3) else trim(cd_upnivel3) end Chave,
                count(no_liberacao) qtde
            from 
                pimscs.liberacao
            where 
                 cd_safra = 
                    (   
                        select
                            max(cd_safra)
                        from
                            pimscs.histprepro
                        where
                            cd_hist not in ('E','S')                            
                ) and
                 fg_status = 'D'
            group by 
                no_queima, 
                trim(cd_upnivel1)||trim(cd_upnivel2)||case when to_number(trim(cd_upnivel3)) < 10 then '0'||trim(cd_upnivel3) else trim(cd_upnivel3) end
        )
        select
            coalesce(u.ordem_corte, d.ordem_corte) as "Ordem de Corte",
            coalesce(u.Chave, d.Chave) as "Chave",
            'U' || '(' || case when u.qtde is null then 0 else u.qtde end  || ')' 
            || ' ' || 
            'D' || '(' || case when d.qtde is null then 0 else d.qtde end || ')' as "Etiquetas de Liberacao"
        from
            Utilizadas u
        full join
            Disponiveis d on
            u.ordem_corte = d.ordem_corte and
            u.Chave = d.Chave) e on
              a."Ordem de Corte" = e."Ordem de Corte" and
              a."Chave" = e."Chave"
      left join
        (
        select--Ultima Ocorrencia do Cadastro de Locais de Producao
            trim(a.cd_upnivel1)||trim(a.cd_upnivel2)||case when to_number(trim(a.cd_upnivel3)) < 10 then '0'||trim(a.cd_upnivel3) else trim(a.cd_upnivel3) end as "Chave",
            a.cd_safra as "Safra",
            a.fg_ocorren as "Ocorrencia Cadastro",
            a.dt_ocorren as "Data da Ocorrencia"
        from
            pimscs.safrupniv3 a
        join
            pimscs.upnivel3 b on    
                a.cd_safra = b.cd_safra and
                a.cd_upnivel1 = b.cd_upnivel1 and
                a.cd_upnivel2 = b.cd_upnivel2 and        
                a.cd_upnivel3 = b.cd_upnivel3
        where
            a.cd_safra = 
                (   
                    select
                        max(cd_safra)
                    from
                        pimscs.histprepro
                    where
                        cd_hist not in ('E','S')
            ) and
            a.dt_ocorren = 
                (
                    select
                        max(a2.dt_ocorren)
                    from
                        pimscs.safrupniv3 a2
                    where
                        a.cd_safra = a2.cd_safra and
                        a.cd_upnivel1 = a2.cd_upnivel1 and
                        a.cd_upnivel2 = a2.cd_upnivel2 and                
                        a.cd_upnivel3 = a2.cd_upnivel3
            ) and
            b.cd_ocup = 1
        ) f on
        a."Safra" = f."Safra" and
        a."Chave" = f."Chave"