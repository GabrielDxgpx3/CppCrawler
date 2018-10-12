#!/bin/bash
#author https://github.com/GabrielDxgpx3/

listar_diretorios(){

	if [ ! -f .lastcompile.txt ]
	then
		diretorios=$(find -iname "*.cpp" | awk '{print substr($1,3);}')
		echo "Modo Normal"
	else
		diretorios=$(find -iname "*.cpp" -type f -cnewer .lastcompile.txt | awk '{print substr($1,3)}')
		echo "Compilando arquivos alterados após "$(cat .lastcompile.txt)

	fi

	erro=0

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
				erro=1
			fi

		done

		if [ $erro -eq 0 ]
		then
			gravar_data_arquivo
		fi
	else
		echo "não foram encontrados arquivos .cpp"
	fi
}

gravar_data_arquivo(){

	date +%F@%R > .lastcompile.txt
}

if [ -z $1 ]
then
	
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


