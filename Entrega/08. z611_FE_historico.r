#Necesita para correr en Google Cloud
# 32 GB de memoria RAM
#256 GB de espacio en el disco local
#8 vCPU


#limpio la memoria
rm( list=ls() )  #remove all objects
gc()             #garbage collection

require("data.table")


options(error = function() { 
  traceback(20); 
  options(error = NULL); 
  stop("exiting after script error") 
})


#------------------------------------------------------------------------------

CorregirCampoMes  <- function( pcampo, pmeses )
{
  tbl <- dataset[  ,  list( "v1" = shift( get(pcampo), 1, type="lag" ),
                            "v2" = shift( get(pcampo), 1, type="lead" )
                         ), 
                   by=numero_de_cliente ]
  
  tbl[ , numero_de_cliente := NULL ]
  tbl[ , promedio := rowMeans( tbl,  na.rm=TRUE ) ]
  
  dataset[ ,  
           paste0(pcampo) := ifelse( !(foto_mes %in% pmeses),
                                     get( pcampo),
                                     tbl$promedio ) ]
}
#------------------------------------------------------------------------------
# reemplaza cada variable ROTA  (variable, foto_mes)  con el promedio entre  ( mes_anterior, mes_posterior )
# en honor a Velen Pennini,  honorable y fiel centinela de la Estadistica Clasica

Corregir_VelenPennini  <- function( dataset )
{
  CorregirCampoMes( "thomebanking", c(201801,202006) )
  CorregirCampoMes( "chomebanking_transacciones", c(201801, 201910, 202006) )
  CorregirCampoMes( "tcallcenter", c(201801, 201806, 202006) )
  CorregirCampoMes( "ccallcenter_transacciones", c(201801, 201806, 202006) )
  CorregirCampoMes( "cprestamos_personales", c(201801,202006) )
  CorregirCampoMes( "mprestamos_personales", c(201801,202006) )
  CorregirCampoMes( "mprestamos_hipotecarios", c(201801,202006) )
  CorregirCampoMes( "ccajas_transacciones", c(201801,202006) )
  CorregirCampoMes( "ccajas_consultas", c(201801,202006) )
  CorregirCampoMes( "ccajas_depositos", c(201801,202006) )
  CorregirCampoMes( "ccajas_extracciones", c(201801,202006) )
  CorregirCampoMes( "ccajas_otras", c(201801,202006) )

  CorregirCampoMes( "ctarjeta_visa_debitos_automaticos", c(201904) )
  CorregirCampoMes( "mttarjeta_visa_debitos_automaticos", c(201904,201905) )
  CorregirCampoMes( "Visa_mfinanciacion_limite", c(201904) )

  CorregirCampoMes( "mrentabilidad", c(201905, 201910, 202006) )
  CorregirCampoMes( "mrentabilidad_annual", c(201905, 201910, 202006) )
  CorregirCampoMes( "mcomisiones", c(201905, 201910, 202006) )
  CorregirCampoMes( "mpasivos_margen", c(201905, 201910, 202006) )
  CorregirCampoMes( "mactivos_margen", c(201905, 201910, 202006) )
  CorregirCampoMes( "ccomisiones_otras", c(201905, 201910, 202006) )
  CorregirCampoMes( "mcomisiones_otras", c(201905, 201910, 202006) )

  CorregirCampoMes( "ctarjeta_visa_descuentos", c(201910) )
  CorregirCampoMes( "ctarjeta_master_descuentos", c(201910) )
  CorregirCampoMes( "mtarjeta_visa_descuentos", c(201910) )
  CorregirCampoMes( "mtarjeta_master_descuentos", c(201910) )
  CorregirCampoMes( "ccajeros_propios_descuentos", c(201910) )
  CorregirCampoMes( "mcajeros_propios_descuentos", c(201910) )

  CorregirCampoMes( "cliente_vip", c(201911) )

  CorregirCampoMes( "active_quarter", c(202006) )
  CorregirCampoMes( "mcuentas_saldo", c(202006) )
  CorregirCampoMes( "ctarjeta_debito_transacciones", c(202006) )
  CorregirCampoMes( "mautoservicio", c(202006) )
  CorregirCampoMes( "ctarjeta_visa_transacciones", c(202006) )
  CorregirCampoMes( "ctarjeta_visa_transacciones", c(202006) )
  CorregirCampoMes( "cextraccion_autoservicio", c(202006) )
  CorregirCampoMes( "mextraccion_autoservicio", c(202006) )
  CorregirCampoMes( "ccheques_depositados", c(202006) )
  CorregirCampoMes( "mcheques_depositados", c(202006) )
  CorregirCampoMes( "mcheques_emitidos", c(202006) )
  CorregirCampoMes( "mcheques_emitidos", c(202006) )
  CorregirCampoMes( "ccheques_depositados_rechazados", c(202006) )
  CorregirCampoMes( "mcheques_depositados_rechazados", c(202006) )
  CorregirCampoMes( "ccheques_emitidos_rechazados", c(202006) )
  CorregirCampoMes( "mcheques_emitidos_rechazados", c(202006) )
  CorregirCampoMes( "catm_trx", c(202006) )
  CorregirCampoMes( "matm", c(202006) )
  CorregirCampoMes( "catm_trx_other", c(202006) )
  CorregirCampoMes( "matm_other", c(202006) )
  CorregirCampoMes( "tmobile_app", c(202006) )
  CorregirCampoMes( "cmobile_app_trx", c(202006) )

  CorregirCampoMes( "internet",    c(201801, 202006, 202010, 202011, 202012, 202101, 202102, 202103) )
  CorregirCampoMes( "tmobile_app", c(202006, 202009, 202010, 202011, 202012, 202101, 202102, 202103) )
}
#------------------------------------------------------------------------------

Corregir_MachineLearning  <- function( dataset )
{
  gc()
  #acomodo los errores del dataset

  dataset[ foto_mes==201901,  ctransferencias_recibidas  := NA ]
  dataset[ foto_mes==201901,  mtransferencias_recibidas  := NA ]

  dataset[ foto_mes==201902,  ctransferencias_recibidas  := NA ]
  dataset[ foto_mes==201902,  mtransferencias_recibidas  := NA ]

  dataset[ foto_mes==201903,  ctransferencias_recibidas  := NA ]
  dataset[ foto_mes==201903,  mtransferencias_recibidas  := NA ]

  dataset[ foto_mes==201904,  ctransferencias_recibidas  := NA ]
  dataset[ foto_mes==201904,  mtransferencias_recibidas  := NA ]
  dataset[ foto_mes==201904,  ctarjeta_visa_debitos_automaticos  :=  NA ]
  dataset[ foto_mes==201904,  mttarjeta_visa_debitos_automaticos := NA ]
  dataset[ foto_mes==201904,  Visa_mfinanciacion_limite := NA ]

  dataset[ foto_mes==201905,  ctransferencias_recibidas  := NA ]
  dataset[ foto_mes==201905,  mtransferencias_recibidas  := NA ]
  dataset[ foto_mes==201905,  mrentabilidad     := NA ]
  dataset[ foto_mes==201905,  mrentabilidad_annual     := NA ]
  dataset[ foto_mes==201905,  mcomisiones      := NA ]
  dataset[ foto_mes==201905,  mpasivos_margen  := NA ]
  dataset[ foto_mes==201905,  mactivos_margen  := NA ]
  dataset[ foto_mes==201905,  ctarjeta_visa_debitos_automaticos  := NA ]
  dataset[ foto_mes==201905,  ccomisiones_otras := NA ]
  dataset[ foto_mes==201905,  mcomisiones_otras := NA ]

  dataset[ foto_mes==201910,  mpasivos_margen   := NA ]
  dataset[ foto_mes==201910,  mactivos_margen   := NA ]
  dataset[ foto_mes==201910,  ccomisiones_otras := NA ]
  dataset[ foto_mes==201910,  mcomisiones_otras := NA ]
  dataset[ foto_mes==201910,  mcomisiones       := NA ]
  dataset[ foto_mes==201910,  mrentabilidad     := NA ]
  dataset[ foto_mes==201910,  mrentabilidad_annual        := NA ]
  dataset[ foto_mes==201910,  chomebanking_transacciones  := NA ]
  dataset[ foto_mes==201910,  ctarjeta_visa_descuentos    := NA ]
  dataset[ foto_mes==201910,  ctarjeta_master_descuentos  := NA ]
  dataset[ foto_mes==201910,  mtarjeta_visa_descuentos    := NA ]
  dataset[ foto_mes==201910,  mtarjeta_master_descuentos  := NA ]
  dataset[ foto_mes==201910,  ccajeros_propios_descuentos := NA ]
  dataset[ foto_mes==201910,  mcajeros_propios_descuentos := NA ]

  dataset[ foto_mes==202001,  cliente_vip   := NA ]

  dataset[ foto_mes==202006,  active_quarter   := NA ]
  dataset[ foto_mes==202006,  internet   := NA ]
  dataset[ foto_mes==202006,  mrentabilidad   := NA ]
  dataset[ foto_mes==202006,  mrentabilidad_annual   := NA ]
  dataset[ foto_mes==202006,  mcomisiones   := NA ]
  dataset[ foto_mes==202006,  mactivos_margen   := NA ]
  dataset[ foto_mes==202006,  mpasivos_margen   := NA ]
  dataset[ foto_mes==202006,  mcuentas_saldo   := NA ]
  dataset[ foto_mes==202006,  ctarjeta_debito_transacciones  := NA ]
  dataset[ foto_mes==202006,  mautoservicio   := NA ]
  dataset[ foto_mes==202006,  ctarjeta_visa_transacciones   := NA ]
  dataset[ foto_mes==202006,  mtarjeta_visa_consumo   := NA ]
  dataset[ foto_mes==202006,  ctarjeta_master_transacciones  := NA ]
  dataset[ foto_mes==202006,  mtarjeta_master_consumo   := NA ]
  dataset[ foto_mes==202006,  ccomisiones_otras   := NA ]
  dataset[ foto_mes==202006,  mcomisiones_otras   := NA ]
  dataset[ foto_mes==202006,  cextraccion_autoservicio   := NA ]
  dataset[ foto_mes==202006,  mextraccion_autoservicio   := NA ]
  dataset[ foto_mes==202006,  ccheques_depositados   := NA ]
  dataset[ foto_mes==202006,  mcheques_depositados   := NA ]
  dataset[ foto_mes==202006,  ccheques_emitidos   := NA ]
  dataset[ foto_mes==202006,  mcheques_emitidos   := NA ]
  dataset[ foto_mes==202006,  ccheques_depositados_rechazados   := NA ]
  dataset[ foto_mes==202006,  mcheques_depositados_rechazados   := NA ]
  dataset[ foto_mes==202006,  ccheques_emitidos_rechazados   := NA ]
  dataset[ foto_mes==202006,  mcheques_emitidos_rechazados   := NA ]
  dataset[ foto_mes==202006,  tcallcenter   := NA ]
  dataset[ foto_mes==202006,  ccallcenter_transacciones   := NA ]
  dataset[ foto_mes==202006,  thomebanking   := NA ]
  dataset[ foto_mes==202006,  chomebanking_transacciones   := NA ]
  dataset[ foto_mes==202006,  ccajas_transacciones   := NA ]
  dataset[ foto_mes==202006,  ccajas_consultas   := NA ]
  dataset[ foto_mes==202006,  ccajas_depositos   := NA ]
  dataset[ foto_mes==202006,  ccajas_extracciones   := NA ]
  dataset[ foto_mes==202006,  ccajas_otras   := NA ]
  dataset[ foto_mes==202006,  catm_trx   := NA ]
  dataset[ foto_mes==202006,  matm   := NA ]
  dataset[ foto_mes==202006,  catm_trx_other   := NA ]
  dataset[ foto_mes==202006,  matm_other   := NA ]
  dataset[ foto_mes==202006,  ctrx_quarter   := NA ]
  dataset[ foto_mes==202006,  tmobile_app   := NA ]
  dataset[ foto_mes==202006,  cmobile_app_trx   := NA ]


  dataset[ foto_mes==202010,  internet  := NA ]
  dataset[ foto_mes==202011,  internet  := NA ]
  dataset[ foto_mes==202012,  internet  := NA ]
  dataset[ foto_mes==202101,  internet  := NA ]
  dataset[ foto_mes==202102,  internet  := NA ]
  dataset[ foto_mes==202103,  internet  := NA ]

  dataset[ foto_mes==202009,  tmobile_app  := NA ]
  dataset[ foto_mes==202010,  tmobile_app  := NA ]
  dataset[ foto_mes==202011,  tmobile_app  := NA ]
  dataset[ foto_mes==202012,  tmobile_app  := NA ]
  dataset[ foto_mes==202101,  tmobile_app  := NA ]
  dataset[ foto_mes==202102,  tmobile_app  := NA ]
  dataset[ foto_mes==202103,  tmobile_app  := NA ]

}
#------------------------------------------------------------------------------
#Esta es la parte que los alumnos deben desplegar todo su ingenio

AgregarVariables  <- function( dataset )
{
  gc()
  #INICIO de la seccion donde se deben hacer cambios con variables nuevas

  #creo un ctr_quarter que tenga en cuenta cuando los clientes hace 3 menos meses que estan
  dataset[  , ctrx_quarter_normalizado := ctrx_quarter ]
  dataset[ cliente_antiguedad==1 , ctrx_quarter_normalizado := ctrx_quarter * 5 ]
  dataset[ cliente_antiguedad==2 , ctrx_quarter_normalizado := ctrx_quarter * 2 ]
  dataset[ cliente_antiguedad==3 , ctrx_quarter_normalizado := ctrx_quarter * 1.2 ]

  #variable extraida de una tesis de maestria de Irlanda
  dataset[  , mpayroll_sobre_edad  := mpayroll / cliente_edad ]

  #se crean los nuevos campos para MasterCard  y Visa, teniendo en cuenta los NA's
  #varias formas de combinar Visa_status y Master_status
  dataset[ , mv_status01       := pmax( Master_status,  Visa_status, na.rm = TRUE) ]
  dataset[ , mv_status02       := Master_status +  Visa_status ]
  dataset[ , mv_status03       := pmax( ifelse( is.na(Master_status), 10, Master_status) , ifelse( is.na(Visa_status), 10, Visa_status) ) ]
  dataset[ , mv_status04       := ifelse( is.na(Master_status), 10, Master_status)  +  ifelse( is.na(Visa_status), 10, Visa_status)  ]
  dataset[ , mv_status05       := ifelse( is.na(Master_status), 10, Master_status)  +  100*ifelse( is.na(Visa_status), 10, Visa_status)  ]

  dataset[ , mv_status06       := ifelse( is.na(Visa_status), 
                                          ifelse( is.na(Master_status), 10, Master_status), 
                                          Visa_status)  ]

  dataset[ , mv_status07       := ifelse( is.na(Master_status), 
                                          ifelse( is.na(Visa_status), 10, Visa_status), 
                                          Master_status)  ]


  #combino MasterCard y Visa
  dataset[ , mv_mfinanciacion_limite := rowSums( cbind( Master_mfinanciacion_limite,  Visa_mfinanciacion_limite) , na.rm=TRUE ) ]

  dataset[ , mv_Fvencimiento         := pmin( Master_Fvencimiento, Visa_Fvencimiento, na.rm = TRUE) ]
  dataset[ , mv_Finiciomora          := pmin( Master_Finiciomora, Visa_Finiciomora, na.rm = TRUE) ]
  dataset[ , mv_msaldototal          := rowSums( cbind( Master_msaldototal,  Visa_msaldototal) , na.rm=TRUE ) ]
  dataset[ , mv_msaldopesos          := rowSums( cbind( Master_msaldopesos,  Visa_msaldopesos) , na.rm=TRUE ) ]
  dataset[ , mv_msaldodolares        := rowSums( cbind( Master_msaldodolares,  Visa_msaldodolares) , na.rm=TRUE ) ]
  dataset[ , mv_mconsumospesos       := rowSums( cbind( Master_mconsumospesos,  Visa_mconsumospesos) , na.rm=TRUE ) ]
  dataset[ , mv_mconsumosdolares     := rowSums( cbind( Master_mconsumosdolares,  Visa_mconsumosdolares) , na.rm=TRUE ) ]
  dataset[ , mv_mlimitecompra        := rowSums( cbind( Master_mlimitecompra,  Visa_mlimitecompra) , na.rm=TRUE ) ]
  dataset[ , mv_madelantopesos       := rowSums( cbind( Master_madelantopesos,  Visa_madelantopesos) , na.rm=TRUE ) ]
  dataset[ , mv_madelantodolares     := rowSums( cbind( Master_madelantodolares,  Visa_madelantodolares) , na.rm=TRUE ) ]
  dataset[ , mv_fultimo_cierre       := pmax( Master_fultimo_cierre, Visa_fultimo_cierre, na.rm = TRUE) ]
  dataset[ , mv_mpagado              := rowSums( cbind( Master_mpagado,  Visa_mpagado) , na.rm=TRUE ) ]
  dataset[ , mv_mpagospesos          := rowSums( cbind( Master_mpagospesos,  Visa_mpagospesos) , na.rm=TRUE ) ]
  dataset[ , mv_mpagosdolares        := rowSums( cbind( Master_mpagosdolares,  Visa_mpagosdolares) , na.rm=TRUE ) ]
  dataset[ , mv_fechaalta            := pmax( Master_fechaalta, Visa_fechaalta, na.rm = TRUE) ]
  dataset[ , mv_mconsumototal        := rowSums( cbind( Master_mconsumototal,  Visa_mconsumototal) , na.rm=TRUE ) ]
  dataset[ , mv_cconsumos            := rowSums( cbind( Master_cconsumos,  Visa_cconsumos) , na.rm=TRUE ) ]
  dataset[ , mv_cadelantosefectivo   := rowSums( cbind( Master_cadelantosefectivo,  Visa_cadelantosefectivo) , na.rm=TRUE ) ]
  dataset[ , mv_mpagominimo          := rowSums( cbind( Master_mpagominimo,  Visa_mpagominimo) , na.rm=TRUE ) ]

  #a partir de aqui juego con la suma de Mastercard y Visa
  dataset[ , mvr_Master_mlimitecompra:= Master_mlimitecompra / mv_mlimitecompra ]
  dataset[ , mvr_Visa_mlimitecompra  := Visa_mlimitecompra / mv_mlimitecompra ]
  dataset[ , mvr_msaldototal         := mv_msaldototal / mv_mlimitecompra ]
  dataset[ , mvr_msaldopesos         := mv_msaldopesos / mv_mlimitecompra ]
  dataset[ , mvr_msaldopesos2        := mv_msaldopesos / mv_msaldototal ]
  dataset[ , mvr_msaldodolares       := mv_msaldodolares / mv_mlimitecompra ]
  dataset[ , mvr_msaldodolares2      := mv_msaldodolares / mv_msaldototal ]
  dataset[ , mvr_mconsumospesos      := mv_mconsumospesos / mv_mlimitecompra ]
  dataset[ , mvr_mconsumosdolares    := mv_mconsumosdolares / mv_mlimitecompra ]
  dataset[ , mvr_madelantopesos      := mv_madelantopesos / mv_mlimitecompra ]
  dataset[ , mvr_madelantodolares    := mv_madelantodolares / mv_mlimitecompra ]
  dataset[ , mvr_mpagado             := mv_mpagado / mv_mlimitecompra ]
  dataset[ , mvr_mpagospesos         := mv_mpagospesos / mv_mlimitecompra ]
  dataset[ , mvr_mpagosdolares       := mv_mpagosdolares / mv_mlimitecompra ]
  dataset[ , mvr_mconsumototal       := mv_mconsumototal  / mv_mlimitecompra ]
  dataset[ , mvr_mpagominimo         := mv_mpagominimo  / mv_mlimitecompra ]

  #Aqui debe usted agregar sus propias nuevas variables

  #valvula de seguridad para evitar valores infinitos
  #paso los infinitos a NULOS
  infinitos      <- lapply(names(dataset),function(.name) dataset[ , sum(is.infinite(get(.name)))])
  infinitos_qty  <- sum( unlist( infinitos) )
  if( infinitos_qty > 0 )
  {
    cat( "ATENCION, hay", infinitos_qty, "valores infinitos en tu dataset. Seran pasados a NA\n" )
    dataset[mapply(is.infinite, dataset)] <<- NA
  }


  #valvula de seguridad para evitar valores NaN  que es 0/0
  #paso los NaN a 0 , decision polemica si las hay
  #se invita a asignar un valor razonable segun la semantica del campo creado
  nans      <- lapply(names(dataset),function(.name) dataset[ , sum(is.nan(get(.name)))])
  nans_qty  <- sum( unlist( nans) )
  if( nans_qty > 0 )
  {
    cat( "ATENCION, hay", nans_qty, "valores NaN 0/0 en tu dataset. Seran pasados arbitrariamente a 0\n" )
    cat( "Si no te gusta la decision, modifica a gusto el programa!\n\n")
    dataset[mapply(is.nan, dataset)] <<- 0
  }

}
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
#Aqui empieza el programa

setwd( "~/buckets/b1/" )

#cargo el dataset
dataset  <- fread( "./datasets/competencia1_historia_2022.csv.gz" )

#creo la carpeta donde va el experimento
# FE  representa  Feature Engineering
dir.create( "./exp/",  showWarnings = FALSE ) 
dir.create( "./exp/FE6110/", showWarnings = FALSE )
setwd("./exp/FE6110/")   #Establezco el Working Directory DEL EXPERIMENTO



#corrijo los  < foto_mes, campo >  que fueron pisados con cero
# Atencion, se debe descomentar SOLO UNO
# Corregir_MachineLearning( dataset )  
# Corregir_VelenPennini( dataset )


#Comentar si no se quiera que funcione
AgregarVariables( dataset )


#--------------------------------------
#estas son las columnas a las que se puede agregar lags o media moviles ( todas menos las obvias )
cols_lagueables  <-  setdiff( colnames(dataset), c("numero_de_cliente", "foto_mes", "clase_ternaria")  )

#ordeno el dataset por <numero_de_cliente, foto_mes> para poder hacer lags
#  es MUY  importante esta linea
setorder( dataset, numero_de_cliente, foto_mes )

#creo los campos lags de orden 1
dataset[ , paste0( cols_lagueables, "_lag1") := shift(.SD, 1, NA, "lag"), 
           by= numero_de_cliente, 
           .SDcols= cols_lagueables ]

#agrego los delta lags
for( vcol in cols_lagueables )
{
  dataset[ , paste0(vcol, "_delta1") := get(vcol)  - get(paste0( vcol, "_lag1"))  ]
}




#--------------------------------------
#grabo el dataset
fwrite( dataset,
        "dataset_6110.csv.gz",
        logical01= TRUE,
        sep= "," )
