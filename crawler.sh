#!/bin/bash
#author https://github.com/GabrielDxgpx3/

listar_diretorios(){
	diretorios=$(find -iname "*.cpp" | awk '{print substr($1,3);}')

	if [[ $diretorios ]]
	then
		for d in $diretorios
		do
			arquivo=$(echo $d | awk -F/ {'print $NF'} | awk -F. {'print $1'})
			echo -ne "Criando objeto de $d..."
			g++ -c $d -o $1"/"$arquivo".o" `pkg-config gtkmm-3.0 --cflags --libs`
			if [ $? -eq 0 ]
			then
				echo -ne "ok\n"
			else
				echo -ne " Erro ao compilar: $d\n"
			fi

		done
	else
		echo "não foram encontrados arquivos .cpp"
	fi
}

if [ -z $1 ]
then
	echo "Pasta destino não informada"

	if [ ! -d objects ]
	then
		echo "Criando uma..."
		mkdir objects
		echo "Pasta objects criada!"
	else
		echo "Usando pasta objects para output"
	fi

	listar_diretorios objects

else
	if [ ! -d $1 ]
	then
		echo "Pasta destino não encontrada"
	else
		listar_diretorios $1
	fi
fi
