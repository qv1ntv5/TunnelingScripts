#!/bin/bash

# En este ejemplo lo que conseguimos es un script que analiza los caracteres que componene cada línea del documento /etc/passwd. Ahora, todo lo que necesitamos son dos funcionalidades más.

#       1. Un script# En este ejemplo lo que conseguimos es un script que analiza los caracteres que componene cada línea del documento /etc/passwd. Ahora, todo lo que necesitamos son dos funcionalidades más.

#       2. Una función que sea capaz de copiar una línea o un conjunto de líneas modificando ciertas partes con un valor a conveniencia.

# 	3. Otra funcionalidad que identifique un substring de una línea y lo copie en una variable.


# i=0
# while read -r line
#	for pos in `seq 1 $(wc -c <<< $(echo $line))`
#	do
#		char=`cut -c $pos <<< $(echo $line)`

#		if [ "$char" == ":" ] 
#		then
#		i=`expr $i + 1`	

#		fi
#	done	

#	echo "Esta línea tiene $i : -- $line"
#	i=0
# done < /etc/passwd

# Si lo que pretendemos es copiar linea a linea el documento podemos simplemente emplear el >> para llevar la línea al apéndice del documento en cuestión.

# while read -r line;
# do
#	echo "$line" >> ~/file.txt

# done < /etc/passwd

# Ahora pasamos a la función que sea capaz de plasmaar la linea correcta acompañada del número identificador de imagen correcto:

function validImg () {
 echo -n "<div style="
 echo -n "\"text-align:center"
 echo -n "\">"
 echo 
 echo -n "	<img src="
 echo -n "\"{{ 'assets/img/Burp/Pasted image $1.png' | relative_url }}" 
 echo -n "\" text-align="
 echo -n "\"center"
 echo -n "\"/>"
 echo
 echo "</div>"
}

# var=1234567890
# print_something $var

# A continuación, presentamos la función para obtener el substring:

# line=1234567890
# for pos in `seq 1 $(wc -c <<< $(echo $line))`
# do
#	if [ $pos -eq 2 ] 
#	then
#		j1=`expr $pos + 5`
#		j2=`expr $post + 9`
#		var=`cut -c $j1-$j2 <<< $(echo $line)`
#	fi
# done

# echo $var

# Ahora todo lo que queda es juntar las partes anteriores para conseguir un script que copie un documento sobre otro fichero y en el proceso analice línea a línea para identificar una imagen. Si a lo largo de toda la línea no la identifica entonces copia la linea tal cual, si identifica una exclamación !, caracter que sólo poseen las imagenes,nentonces no copia la línea sino que coge el numero identificador del string y lo pasa a una variable que luego s eapsa como parámetro a la función que copia la linea correcta:


i=0
while read -r line
do
	for pos in `seq 1 $(wc -c <<< $(echo $line))`
	do
		char=`cut -c $pos <<< $(echo $line)`
		if [ "$char" == "!" ] 
		then 
			char2=`cut -c $(expr $pos + 1) <<< $(echo $line)`
		
			if [ "$char2" == "[" ] 
			then
				i=1
			fi	
		fi
	done

	if [ $i -eq 1 ]
	then
	       var1=`cut -d "." -f1 <<< $(echo $line)`
	       var2=`cut -d " " -f3 <<< $(echo $var1)`
	       echo $var2
	       validImg $var2 >> $2
	       i=0 
	else 
		echo $line >> $2
	fi
done < $1

# Este script completado copia el documento sustituyendo el enlace de la imagen por uno adecudo para ser procesado por jekyll. Funciona de la siguiente manera:

# 	En primer lugar se emplea el loop "while read" para que desglose linea a linea un documento que se pasa como primer parámetro del comando de ejecución tal y como se puede ver al final del script. Seguidamente, para cada línea (line) se forma un bucle que 'for' que tiene tantas iteraciones como caracteres tiene la linea y se analizan cada uno de ellos para comprobar si alguno es un signo de exclamación (!) que es el término por el que empieza el enlace a una fotogragía. Si esto es correcto se realiza una segunda comprobación con el siguiente caracter y si se trata de un corchete ([) entonces hay confirmación de que la linea es el enlace a una foto y se concreta a través de un marcador booleano, (i=1) que por defecto tiene valor cero tal y como se puede ver al principio.

#	 En la segunda parte del código, se analiza el marcador booleano. Si este es igual a 1 entonces en primer lugar se divide la línea en función del único punto que tiene y se coge la primera parte, aquella que contiene el número de identificación y otras cosas. Seguidamente, se divide dicha parte por espacios y se coge la tercera dejándonos sólo con el número identificador. Para mayor seguridad se saca por pantalla dicho número y se pasa como parámetro a la función antes construida y se cambia el valor del marcador booleano. De lo contrario, simplemente se copia la línea entera al fichero que se pasa como 2º parámetro al comando de ejecución.

# Así, se tiene un script que copia el contenido del fichero que se pasa como primer paráemtro al fichero que tiene por nombre el segundo parámetro cambiando los enlaces.

# USO: ./scriptApuntes.sh origen.txt destino.txt
