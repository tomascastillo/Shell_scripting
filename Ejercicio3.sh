#!/bin/bash

# Trabajo Practico Nº2, Ejercicio 3, Entrega 2.

							#---- Funcion del Help
function pedir_ayuda(){
echo ""
echo ""
echo ""
echo "NAME"
echo "		Ejercicio3.sh"
echo ""
echo "DESCRIPTION"
echo ""
echo "El script permite realizar cualquiera de las siguientes acciones sobre un directorio dado:"
echo ""
echo "[ -a  ] Ante archivos con el mismo contenido ( idénticos ), conservar solo uno y eliminar el resto."
echo "[ -m dir_destino] Mover todos los archivos a un único directorio."
echo "[ -e  ] Eliminar los directorios que se encuentran vacíos. "
echo ""
echo ""
echo "Casos posibles de ejecución:"
echo ""
echo "./ej3.sh -m dir_destino"	
echo "./ej3.sh -m dir_destino directorio  "	
echo "./ej3.sh -m dir_destino -r"	
echo "./ej3.sh -m dir_destino -r directorio"	
echo ""
echo "./ej3.sh -a"
echo "./ej3.sh -a directorio"  		
echo "./ej3.sh -a -r"				
echo "./ej3.sh -a -r directorio"		
echo ""
echo "./ej3.sh -e"				
echo "./ej3.sh -e directorio" 		
echo "./ej3.sh -e -r"				
echo "./ej3.sh -e -r directorio" 		
echo ""
echo "En caso de existir un orden distinto en los parametros o parametros de mas el script dara error"
echo ""
echo ""
echo ""
}



							#---- Funciones de Validacion
function validar_cantParam(){								# 0 = exito, 1 = error encontrado
	if [[ "$1" == "-m" && "$#" > 1 ]]; then
		return 0
	else
		if [ "$#" -gt 0 ]; then
			return 0
		else
			return 1
		fi
	fi
}



							# ---- Main -----

if [[ $1 = "-h" || $1 = "-help" || $1 = "-?" ]]; then
	pedir_ayuda
	exit
fi

if [[ $1 = "-r" || $2 = "-r" || $3 = "-r" || $4 = "-r" ]]; then
	recursivo=1
fi

if [[ $1 = "-m" || $2 = "-m" || $3 = "-m" || $4 = "-m" ]]; then
	mover=1
fi

if [[ $1 = "-a" || $2 = "-a" || $3 = "-a" ]]; then
	cleanall=1
fi

if [[ $1 = "-e" || $2 = "-e" || $3 = "-e" ]]; then
	eliminar=1
fi

validar_cantParam $1 $#


# recordar que $? me indica el valor de finalizacion del ultimo comando
if [ $? -eq 1 ]; then # comparo el resultado de validar_cantParam
	echo "ERROR: Cantidad de parametros incorrectos, usar -h para ver la ayuda."
	exit
fi



marca=0 									#ingreso marca como 0 para luego preguntar por la misma y si no ingreso por ningun if no se utilizo correctamente la llamada
		# Casos Posibles para -m

if [[ "$mover" == 1 && "$#" == 2 && "$recursivo" != 1 ]]; then
	ruta_inicio="$(pwd)"
	ruta_destino="$2"
	((marca++))
fi

if [[ "$mover" == 1 && "$#" == 3 && "$recursivo" != 1 ]]; then
	ruta_inicio="$3"
	ruta_destino="$2"
	((marca++))
fi

if [[ "$mover" == 1 && "$#" == 3 && "$recursivo" == 1 ]]; then
	ruta_inicio="$(pwd)"
	if [ "$2" == "-r" ]; then
		ruta_destino="$3"
	else
	ruta_destino="$2"
	fi
	((marca++))
fi

if [[ "$mover" == 1 && "$#" == 4 && "$recursivo" == 1 ]]; then
	if [ "$2" == "-r" ]; then
		ruta_inicio="$4"
		ruta_destino="$3"
	fi
	if [ "$3" == "-r" ]; then
		ruta_inicio="$4"
		ruta_destino="$2"
	fi
	if [ "$4" == "-r" ]; then
		ruta_inicio="$3"
		ruta_destino="$2"
	fi
	((marca++))
fi


		# Casos Posibles para -a

if [[ "$cleanall" == 1 && "$#" == 1 && "$recursivo" != 1 ]]; then
	ruta_inicio="$(pwd)"
	((marca++))
fi

if [[ "$cleanall" == 1 && "$#" == 2 && "$recursivo" != 1 ]]; then
	ruta_inicio="$2"
	((marca++))
fi

if [[ "$cleanall" == 1 && "$#" == 2 && "$recursivo" == 1 ]]; then
	ruta_inicio="$(pwd)"
	((marca++))
fi

if [[ "$cleanall" == 1 && "$#" == 3 && "$recursivo" == 1 ]]; then
	if [ "$3" == "-r" ]; then
		ruta_inicio="$2"
	fi
	if [ "$2" == "-r" ]; then
		ruta_inicio="$3"
	fi
	((marca++))
fi

		# Casos Posibles para -e

if [[ "$eliminar" == 1 && "$#" == 1 && "$recursivo" != 1 ]]; then
	ruta_inicio="$(pwd)"
	((marca++))
fi

if [[ "$eliminar" == 1 && "$#" == 2 && "$recursivo" != 1 ]]; then
	ruta_inicio="$2"
	((marca++))
fi

if [[ "$eliminar" == 1 && "$#" == 2 && "$recursivo" == 1 ]]; then
	ruta_inicio="$(pwd)"
	((marca++))
fi

if [[ "$eliminar" == 1 && "$#" == 3 && "$recursivo" == 1 ]]; then
	if [ "$3" == "-r" ]; then
		ruta_inicio="$2"
	fi
	if [ "$2" == "-r" ]; then
		ruta_inicio="$3"
	fi
	((marca++))
fi

if [ "$marca" == 0 ]; then
	echo "Parametros incorrectamente ingresados, utilice -h para ver los casos de ejecución"
	exit 0
fi




		# Laburo de -a


if [[ "$cleanall" == 1 && "$recursivo" != 1 ]]; then							# Si NO es recursivo uso maxdepth para limitar el find
	find "$ruta_inicio" -maxdepth 1 -type f | while read i; do
		find "$ruta_inicio" -maxdepth 1 -type f | while read j; do
			if [ "$i" != "$j" ]; then
				sum1=$((md5sum "$i" 2>/dev/null) | cut -f 1 -d ' ' ) 2>/dev/null
      				sum2=$((md5sum "$j" 2>/dev/null) | cut -f 1 -d ' ' ) 2>/dev/null
				
				if [ "$sum1" == "$sum2" ]; then
      					rm "$i" 2>/dev/null
				fi
    			fi
  		done
	done
fi


if [[ "$cleanall" == 1 && "$recursivo" == 1 ]]; then							# El find por default es recursivo
	find "$ruta_inicio" -type f | while read i; do
		find "$ruta_inicio" -type f | while read j; do
			if [ "$i" != "$j" ]; then
				sum1=$((md5sum "$i" 2>/dev/null) | cut -f 1 -d ' ' ) 2>/dev/null
      				sum2=$((md5sum "$j" 2>/dev/null) | cut -f 1 -d ' ' ) 2>/dev/null
				
				if [ "$sum1" == "$sum2" ]; then
      					rm "$i" 2>/dev/null
				fi
    			fi
  		done
	done
fi



		# laburo de -m

mkdir "$ruta_destino" 2>/dev/null

if [[ "$mover" == 1 && "$recursivo" != 1 ]]; then								# Si NO es recursivo uso maxdepth para limitar el find
	find "$ruta_inicio" -maxdepth 1 -type f | while read i; do
		find "$ruta_inicio" -type f -maxdepth 1 | while read j; do
			if [[ "$(basename "$i")" == "$(basename "$j")" && "$(dirname "$i")" != "$(dirname "$j")" ]]; then
				diri=""$(dirname "$i")"/"$(basename "$(dirname "$i")")"_"$(basename "$i")""
				dirj=""$(dirname "$j")"/"$(basename "$(dirname "$j")")"_"$(basename "$j")""
				mv -T "$i" "$diri" 2>/dev/null
				mv -T "$j" "$dirj" 2>/dev/null
   			fi
  		done
	done

find "$ruta_inicio" -maxdepth 1 -type f | while read i; do
	mv -t "$ruta_destino" "$i"
done			
fi


if [[ "$mover" == 1 && "$recursivo" == 1 ]]; then								# El find por default es recursivo
	find "$ruta_inicio" -type f | while read i; do
		find "$ruta_inicio" -type f | while read j; do
			if [[ "$(basename "$i")" == "$(basename "$j")" && "$(dirname "$i")" != "$(dirname "$j")" ]]; then
				diri=""$(dirname "$i")"/"$(basename "$(dirname "$i")")"_"$(basename "$i")""
				dirj=""$(dirname "$j")"/"$(basename "$(dirname "$j")")"_"$(basename "$j")""
				mv -T "$i" "$diri" 2>/dev/null
				mv -T "$j" "$dirj" 2>/dev/null
   			fi
  		done
	done

find "$ruta_inicio" -type f | while read i; do
	mv -t "$ruta_destino" "$i"
done

fi



		# Laburo de -e

if [[ "$eliminar" == 1 && "$recursivo" == 1 ]]; then	
	find "$ruta_inicio" -type d -empty -delete								# El find por default es recursivo
fi

if [[ "$eliminar" == 1 && "$recursivo" != 1 ]]; then	
	find "$ruta_inicio" -maxdepth 1 -type d -empty -delete							# Si NO es recursivo uso maxdepth para limitar el find
fi





