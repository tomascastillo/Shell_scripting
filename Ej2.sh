#!/bin/bash
declare -A vecHash
declare -A vecHashNuevos
declare -A vecHashUsersIdUsr
declare -A vecHashNuevosIdUsr
declare -A vecHashFinal

function ayuda(){
	echo " Ejemplo : ./Ejercio2.sh ./usuarios.txt ./nuevos.txt "
	echo " Los archivos deben ser de texto plano "
	echo " Descripcion: Dados dos archivos recibidos por parametro, el primero de usuarios existentes en un directorio y el segundo de usuarios nuevos, se actualizara el archivo de usuarios existentes en base a los usuarios nuevos. En el archivo errores.log se escribiran los errores que ocurrieron durante la ejecucion y en el archivo usuarios.log habra un registro de ejecucion del script "
	exit
}

function validar(){
	if [ $# -ne 2 ] ;
	then
		echo "La cantidad de parametros no es la correcta"
		exit
	else
		echo "La cantidad de parametros estan bien"
	fi

	if [ -f "$1" ] ;
	then
		echo "El archivo $1 existe"
	else
		echo "Falta un archivo"
		exit
	fi

	if [ -f "$2" ] ;
	then
		echo "El archivo $2 existe"
	else
		echo "Falta un archivo"
		exit
	fi

	if [ -s "$1" ] ;
	then
		echo "El archivo $1 no esta vacio"
	else
		echo "El archivo $1 esta vacio"
		exit
	fi

	if [ -s "$2" ] ;
	then
		echo "El archivo $2 no esta vacio"
	else
		echo "El archivo $2 esta vacio"
		exit
	fi

	file -i "$1" | grep text/plain >> /dev/null
	if [ $? != 0 ] ;
	then
		echo "El archivo $1 no es de texto"
		exit
	fi

	file -i "$2" | grep text/plain >> /dev/null
	if [ $? != 0 ] ;
	then
		echo "El archivo $2 no es de texto"
		exit
	fi

}

function validarCantidadCaracteres(){
	cantidadC=16
	if [ ${#1} -le $cantidadC ] ;
	then
		echo "La cantidad de caracteres de $1 es correcta"
	else
		echo "La cantidad de caracteres es mayor a 16 caracteres, se ha limitado el nombre de usuario a esa cantidad"
		return 100
	fi
}


function userExiste(){
#recibe por parametros el usuario a comprobar y el vector de usuarios actuales
	for elemento6 in ${!vecHashUsersIdUsr[*]}
	do
		if [[ "${vecHashUsersIdUsr[$elemento6]}" == "$cadenaUserFinal" ]];
			then
				return 3
		fi
	done
	return 2
}

function dniExiste(){

	for elemento7 in ${!vecHashUsersIdUsr[*]}
	do
			if [[ $elemento7 == $1 ]];
			then
				return 3
			fi
	done
	return 2
}

if [ "$1" == "-h" ] ;
then
	ayuda
fi

validar $1 $2

while IFS=\; read id user nombre apellido
do
	vecHash[$id]=$user";"$nombre";"$apellido
#done <usersV2.txt
done < $1

while IFS=\; read idNuevo nombreNuevo apellidoNuevo
do
	vecHashNuevos[$idNuevo]=$nombreNuevo";"$apellidoNuevo
#done <nuevosV2.txt
done < $2

for elemento2 in ${!vecHash[*]}
do
	vecHashUsersIdUsr[$elemento2]=$(echo ${vecHash[$elemento2]} | cut -d';' -f 1)
done

for elemento3 in ${!vecHashUsersIdUsr[*]}
do
	vecHashUsersIdUsr[$elemento2]=$(echo ${vecHash[$elemento2]} | cut -d';' -f 1)
done

for elemento4 in ${!vecHashNuevos[*]}
do
	cadenaUser=$(echo ${vecHashNuevos[$elemento4]} | cut -d';' -f 1)
	#nombreNuevo=$(echo${vecHashNuevos[$elemento4]} | cut -d';' -f 1)
	nombreNuevo=$cadenaUser
	primerLetra=$(echo ${cadenaUser:0:1})
	apellidoAConcatenar=$(echo ${vecHashNuevos[$elemento4]} | cut -d';' -f 2)
	apellidoNuevo=$apellidoAConcatenar
	cadenaUserFinal=$(echo $primerLetra$apellidoAConcatenar)
	iter = 1
	userExiste $cadenaUserFinal
	while [ "$?" == "3" ] ; do
			#echo $?
			$((++iter))
			#echo "iter: $iter"
			cadenaUser=$(echo ${vecHashNuevos[$elemento4]} | cut -d';' -f 1)
			segundaLetra=$(echo $cadenaUser| cut -c 1-$iter)
			cadenaUserFinal=$(echo $segundaLetra$apellidoAConcatenar)
			#echo "Cadena user final\parcial : $cadenaUserFinal"
			userExiste $cadenaUserFinal
	done
	validarCantidadCaracteres $cadenaUserFinal
	if [ "$?" == 100 ] ;
	then
		cantidadC = 16
		cadenaAEscribir=$(echo $cadenaUserFinal| cut -c 1-$cantidadC)
		unset cadenaUserFinal
		cadenaUserFinal=$(echo $cadenaAEscribir)
	fi
	#echo "cadena A escribir: $cadenaUserFinal"
	dt=$(date '+%d/%m/%Y %H:%M:%S')
	#errores="errores.log"
	if [ -f "errores.log" ] ;
	then
	rm errores.log
	fi
	dniAComprobar=$elemento4
	dniExiste $dniAComprobar
	if [[ "$?"  == "3" ]];
	then
		echo " $dt :: ERROR :: $dniAComprobar :: El dni ya existia " >> errores2.log
		echo "El dni $dniAComprobar YA EXISTIA y debe se ESCRITA en ERRORES"
		#FUNCTION ESCRIBIRENERROR
	else
		#echo "El dni $dniAComprobar NO EXISTIA Y DEBE SER AGREGADO" #escribir ok
		vecHashFinal[$elemento4]=$cadenaUserFinal
		echo "$elemento4;${vecHashFinal[$elemento4]};$nombreNuevo;$apellidoNuevo" >> $1
		#echo "vecHashFinal : DNI: $elemento4 - User: ${vecHashFinal[$elemento4]} "
		echo " $dt :: OK :: $dniAComprobar :: $cadenaUserFinal " >> usuarios.log
		#actualizar archivo
		vecHashUsersIdUsr[$elemento4]=$cadenaUserFinal
	fi
	unset iter
	vecHashNuevosIdUsr[$elemento4]=$cadenaUserFinal
	#echo "vecHashNuevosIdUsr : DNI: $elemento4 - User: ${vecHashNuevosIdUsr[$elemento4]}"
done

if [ -f errores.log ] ;
then
	mv errores2.log errores.log
else
	cp errores2.log errores.log
	rm errores2.log
fi

echo "Terminacion exitosa del script"


unset vecHash
unset vecHashNuevos
unset vecHashNuevosIdUsr
unset vecHashUsersIdUsr
unset vecHashFinal
