
	:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	::                                                                 ::
	::  Script          :Menu_AutoInstala.bat                          ::
	::  Versão          :0.0.23 - 22/04/2024                           ::
	::  Descrição       :Lista setup de instaladores diversos.         ::
	::  Argumentos      :Sem entrada de argumentos.                    ::
	::  Autor           :Valmir Morais                                 ::
	::  E-mail          :morvalmir@gmail.com                           ::
	::                                                                 ::
	:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	
	@echo off
	set/p=[?25l<nul
	chcp 65001 >nul
	mode 60,5
	title Menu de Instalação
	setlocal enabledelayedexpansion
	
	cd /d "%~dp0\APPS\" && (
		fltmc.exe >nul 2>&1 || (
			powershell.exe -Command "Start-Process cmd \"/k %~dpnx0\" -Verb RunAs" || (
				call :sem_pasta_arquivo "LANÇAR COMO ADMINISTRADOR."
			)
			exit
		)
	)||(
		call :sem_pasta_arquivo "DIRETÓRIO DE APPS AUSENTE."
	)
	
	:prossiga
	
	:::::::::::::::Buscando arquivos para formar a lista de instaladores.:::::::::::::::
		pushd "%~dp0\APPS\"
			set count=0
			for /r %~dp0\APPS\ %%a in (*.exe *.msi *.lnk) do (
				if !count! leq 98 (
					set /a count+=1
					set "menu[!count!]="%%~fa""
					set "menu1[!count!]=%%~nxa                                    "
				)
			)
			if !count!==0 ( call :sem_pasta_arquivo " DIRETÓRIO DE APPS VAZIO. ")
			if %count% lss 10 (set "spc1= ")
			if %count% geq 10 (set "spc1=")
			for /f %%V in ('set /a x^=!count!%%2') do (
				if %%V equ 0 (set "spc2=rem ")
				if %%V equ 1 (set "spc2=")
			)
		popd

	::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

	@REM %= Cálculo para ajuste de exibição em colunas =%	
	set /a meio_count=(!count!+3)/2
	@rem %= Cálculo para tamanho da moldura =%
	set /a um_count=!meio_count!-1
	@rem %= Cálculo para tamanho do terminal =%
	set /a lines=!meio_count!+8

	::::::::::::: Animação durante abertura - Desliza para baixo ::::::::::::::::::::::
	echo [3;30;47m                        CARREGANDO                        [m
		for /l %%A in (1,1,%lines%) do (
			set/p"=[2K[8;%%A;60t[0E[3;30;47m                         CARREGANDO                         [m"<nul
			pathping -4 -h 1 -n -p 5 -q 1 -w 1 127.1 >nul 
		)
	::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

	::::::::::::::::::::formação do cabeçalho apresentado em tela:::::::::::::::::::::::
	call :tam_intervalo "%computername%" nome_pc
	call :tam_intervalo "%username%" nome_usu

		for /f %%b in ('date ^/t') do set "data=%%b"
	set /a counto=0
	set /a counta=0
		for %%i in (^
			"╔════════════════════════════════════════════════════════╗"^
			"║                                                        ║"^
			"║                                                        ║"^
			"╚════════════════════════════════════════════════════════╝"
		) do (
			set /a counta+=1
			set "menu0[!counta!]=%%~i"
			set "exib_molde=!exib_molde! "%%~i""
		)
		for %%I in (^
			"COMPUTADOR^:           USUÁRIO^:              DATA^:" ^
			"%nome_pc%%nome_usu%%data%"
		) do (
			set /a counto+=1
			set "sobremenu[!counto!]=%%~I"
		)
	::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

	:: Lista de packers com seus identificadores e switches para instalação silenciosa::
	set "packers[0]=Inno Setup"
	set "packers_switches[0]=/sp- /silent /supressmsgboxes /norestart"
	set "packers[1]=NSIS"
	set "packers_switches[1]=/S /NCRC"
	set "packers[2]=InstallShield"
	set "packers_switches[2]=/s /v/qn"
	set "packers[3]=WiX Toolset"
	set "packers_switches[3]=/quiet /qn"
	set "packers[4]=Nullsoft Scriptable Install System"
	set "packers_switches[4]=/S"
	set "packers[5]=Java installation"
	set "packers_switches[5]=/s"
	set "packers[6]=INnO"
	set packers_switches[6]="-q"
	set "packers[7]=Advanced Installer"
	set "packers_switches[7]=/qn"
	set "packers[8]=Squirrel"
	set packers_switches[8]="--silent"
	set "packers[9]=PaxCompiler"
	set "packers_switches[9]=/silent"
	set "packers[10]=Smart Install Maker"
	set "packers_switches[10]=/S"
	set "packers[11]=Silent Install Builder"
	set "packers_switches[11]=/silent /verysilent"
	set "packers[12]=WinRAR"
	set "packers_switches[12]=/S"
	set "packers[13]=7-Zip Installer"
	set "packers_switches[13]=/S"
	set "packers[14]=mozilla.org0"
	set "packers_switches[14]=/S"
	set "packers[15]=Google%%20Chrome"
	set "packers_switches[15]=/silent /install"
	set "packers[16]=Wise InstallMaster"
	set "packers_switches[16]=/s"
	set "packers[17]=Symantec.Norton"
	set "packers_switches[17]= "
	set "packers[18]=SYMANTEC SUPPORT TOOLS"
	set "packers_switches[18]= "
	set "packers[19]=WARSAWCLIENT"
	set "packers_switches[19]= "
	set "packers[20]=AVCTreePartition"
	set "packers_switches[20]= "
	
	set idx=0
	:qtd_idx
		if "!packers[%idx%]!" neq "" (
		 @REM echo "!packers[%idx%]!"|findstr \"\" || (
			set /a idx+=1
			goto :qtd_idx
		)
	set /a idx-=1
	::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

	:inicio
	cls
	for %%i in (ch first secon) do set "%%i="

	:sub_inicio
	set /a tam_term=6
	mode 60,%lines%
	set /p"=[2J[H[m"<nul
	title Menu de instalação

	::::::::::::::::::::::::::::Exibição do cabeçalho.::::::::::::::::::::::::::::::::::
		for /l %%n in (1,1,!counta!) do (echo [1C[1m!menu0[%%n]!)
	<nul set /p"=[2H"
		for /l %%m in (1,1,!counto!) do (echo [m[3C[3m!sobremenu[%%m]![m)
	::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

	echo.
	echo [1C[1;38;5;253;48;5;19m┌───────────────────────────┬────────────────────────────┐
		for /l %%B in (1,1,!um_count!) do (echo [1C│                                                        │)
	set/p"=[1C└───────────────────────────┴────────────────────────────┘"<nul

	:: Exibição da lista de instaladores dividida em colunas
	set/p"=[5;0H"<nul
	echo.
		for /l %%a in (1,1,!count!) do (
			 @REM for /f "tokens=1,2,* delims=. " %%K in ("!menu[%%a]!") do (set "tmp_name=%%K%%M")
			for /f "delims=" %%K in ("!menu[%%a]!") do (set "tmp_name=%%~nK                                    ")
			if %%a lss !meio_count! (
				if %%a lss 10 (echo [2C0%%a. !tmp_name:~0,23!│) else (echo [2C%%a. !tmp_name:~0,23!│)
			) else (
				if %%a lss 10 (
					echo [!tam_term!;31H0%%a. !tmp_name:~0,23!
				) else (
					echo [!tam_term!;31H%%a. !tmp_name:~0,23!
				)
			set /a tam_term+=1
			)
		)
	%spc2%echo.
	echo [m
	::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

	:: Entrada de opções do usuário
	:capta 
	set/p"=[m[0K[0G"<nul
	echo [1C[1;48;5;234;38;5;214mEntre de 1 a %count%%spc1%:                                          [m
	echo [1C[1;48;5;234;38;5;214m                                          [38;5;232;3mb[38;5;232;3my [38;5;232;3mV[38;5;232;3ma[38;5;232;3ml[38;5;232;3mm[38;5;232;3mi[38;5;232;3mr [38;5;232;3mM[38;5;232;3mo[38;5;232;3mr[38;5;232;3ma[38;5;232;3mi[38;5;232;3ms[m
	<nul set/p"=[1C[1;48;5;234;38;5;214mA[38;5;242;1m=Ajuda [1;38;5;214mEspaço[38;5;242;1m=Separa ítens [1;38;5;214m1-x[38;5;242;1m=Intervalo de ítens [1;38;5;214m00[38;5;242;1m=Sair[38;5;242;23m[m[2A[19G"

	::Tratamento das teclas digitadas
		if not "!ch!"=="" (set/p"=[1;48;5;234;38;5;253m!ch!"<nul)
		
		@rem Laço para testar os dois algarismos exigidos, um por vez.
		for %%k in (first secon) do (
			set/p"=[?25h"<nul
			@rem Linha de captura de digitação. =%
			for /F "eol=0 delims=" %%L in ('xcopy /qw "%~f0" "%~f0" 2^>NUL') do (
				set/p"=[?25l"<nul
				set "capt=%%L"
				
				if "!capt:~-1!"=="-" (
					if defined ch if not "!ch:~-1!"=="-" set "ch=!ch!!capt:~-1!"
					goto :capta
				)

				@rem Caso a tecla pressionada seja "a/A" (não c/s), exibe o help. =%
				if /i "!capt:~-1!"=="a" (
					CALL :instrucoes
				)
				set "%%k=!capt:~-1!"

				@rem Esse bloco condicional identifica por comparação a digitação da tecla "Backspace".
				If "!%%k!"=="" (
					if defined ch set "ch=!ch:~0,-1!"
					goto :capta			
				)

				@rem Se estiver definida e for um espaço...
				if defined %%k if "!%%k!"==" " (
					@rem "ch" vai receber o valor atual da variável "ch" concatenada com o valor da variável,
					@rem No caso, o caracter de "espaço" armazenado.
					set "ch=!ch!!%%k!"
					goto :capta
				)

				@rem Esse bloco efetiva a digitação da primeira tecla.
				if "%%k"=="first" (
					@rem Este bloco condicional certifica que sejam entregues apenas números nessa posiçõa inicial.
					echo.!first!|%systemroot%\system32\findstr.exe "[0123456789]" >nul||(goto :capta)
					@rem Esse trecho certifica que valor nulo para a variável "ch" assuma o valor do algarismo digitado.
					if "!ch!"=="" (set "ch=!%%k!") else (set "ch=!ch!!%%k!")
					<nul set/p"=[1;48;5;234;38;5;253m!%%k!"
				)
				@rem Nesse trecho é tratado e aceito o espaço para o algarismo da segunda posição. 
				@rem  Trata ainda, como no primeiro algarismo, para armazenar somente os números digitados.
				if "%%k"=="secon" (
					echo.!secon!|%systemroot%\system32\findstr.exe /rc:"[0123456789]" >nul&&(
						set "ch=!ch!!%%k!"
						<nul set/p"=[1;48;5;234;38;5;253m!%%k!"
					)
				)
			)
		)
		if "%secon%"=="" (goto :continue)

	:faz_de_novo
	set/p"=[?25h"<nul
		for /F "eol=0 delims=" %%n in ('xcopy /qw "%~f0" "%~f0" 2^>NUL') do (
			set/p"=[?25l"<nul
			set "sem=%%n"
			@rem Caso a tecla pressionada seja "a/A" (não c/s), exibe o help.
			if /i "!sem:~-1!"=="a" (
				CALL :instrucoes
			)
			set "sem=!sem:~-1!"
		)
		If "%sem%"=="" (
			if defined ch set "ch=!ch:~0,-1!"
			set "sem="
			goto :capta
		)
		if "%sem%" equ " " (
			set "ch=%ch%%sem%"
			set "sem="
			goto :capta
		)
		if "%sem%"=="-" (
			set "ch=%ch%%sem%"
			set "sem="
			goto :capta
		)
		if "%sem%" neq "" (set "sem=" & goto :faz_de_novo)

	:continue

	set/p"=[?25l[m"<nul
	::Tratando os zeros nos ítens selecionados.
		if "%ch%"=="00" (goto :escape)
		if "%ch%"=="0" (set "ch="&goto :capta)		%= Não permite ítem zerado =%
	set /a lin=0
		for %%R in (%ch%) do (
			set "#=%%R"
			set "##="
				echo %%R|%systemroot%\system32\findstr.exe /x "[0][123456789]" >nul 2>&1 && (	%= Identifica ítem com zero a esquerda =%
					set "#=!#:~-1!"
					call set ch=!ch:%%R=%%#%%!
				)
				@REM %= Identifica faixa de ítens =%
				echo %%R|%systemroot%\system32\findstr.exe /x "[123456789]-[0123456789] [123456789]-[0123456789][0123456789] [123456789][0123456789]-[123456789][0123456789] [123456789][0123456789]-[0123456789] " >nul 2>&1 && (
					for /f "tokens=1,2 delims=-" %%P in ("%%R") do (
						if %%Q geq %%P (
							for /l %%s in (%%P,1,%%Q) do (
								if %%s neq 0 if %%s neq 00 (set "##=!##! %%s")
							)
						)
						if %%P gtr %%Q (
							for /l %%s in (%%Q,1,%%P) do (
								if %%s neq 0 if %%s neq 00 (set "##=!##! %%s")
							)
						)
					)
					call set ch=!ch:%%R=%%##%%!
				)
			@REM )
		)

	mode 60,22
		for /l %%n in (1,1,!counta!) do (echo [1C[38;5;241;1m!menu0[%%n]!)
	<nul set /p"=[2H"
		for /l %%m in (1,1,!counto!) do (echo [3C[38;5;241;3m!sobremenu[%%m]![m)
	echo.

	echo [1C[48;5;19;1m┌────────────────────────────────────────────────────────┐
		for /l %%B in (1,1,15) do (echo [1C│                                                        │)
	<nul set/p"=[1C└────────────────────────────────────────────────────────┘[m"
	<nul set/p"=[22;0H[1C[38;5;242;1m                        AGUARDE...                        "
	set "barra_andamento=                        AGUARDE...                        "
	<nul set/p"=[5;0H[m"
	for %%i in (cont_abaixo qtd_item item_ini) do set "%%i=0"
	set "_executados_=$"
		for %%g in (!ch!) do (
			set nao_identificado=1
			if not "%%g" == "00" (
				set /a qtd_item+=1
				if !qtd_item! leq 15 (
					set /a item_ini=1
				)
				if !qtd_item! gtr 15 (
					set /a item_ini=!qtd_item!-14
				)
				set "alinha=00%%g"
				set "menu_inst[!qtd_item!]=[2C[48;5;19m!alinha:~-2!"
				echo.%%g|%systemroot%\system32\findstr.exe /x "!_executados_!" >nul 2>nul && call set "menu_inst[!qtd_item!]=[38;5;190m%%menu_inst[!qtd_item!]%% -            Repetida, não Executar.           - --- [m"
				echo.%%g|%systemroot%\system32\findstr.exe /vx "!_executados_!" >nul 2>nul && (
					echo.%%g|%systemroot%\system32\findstr.exe /x "[-][0123456789] [-][0123456789][0123456789] [0]-[0123456789] [0]-[0123456789][0123456789]" >nul 2>nul && (
						call set "menu_inst[!qtd_item!]=%%menu_inst[!qtd_item!]%% [1;38;5;166m-     SEM INSTALADOR. ERROR: FAIXA INVÝLIDA^!   - --- [m"
					) || (
						if "!_executados_!"=="$" (
							set "_executados_=%%g"
						) else (
							set "_executados_=!_executados_! %%g"
						)
						if %%g gtr %count% (
							call set "menu_inst[!qtd_item!]=[1;38;5;190m%%menu_inst[!qtd_item!]%% -               SEM INSTALADOR^!                - --- [m"
						) else (
							call set "menu_inst[!qtd_item!]=%%menu_inst[!qtd_item!]%% [48;5;19;1m- Executar... !menu1[%%g]:~0,32!     [m"
							<nul set/p"=[5;0H"
							for /l %%C in (!item_ini!,1,!qtd_item!) do (
								echo.
								if not "!menu_inst[%%C]!"=="" (<nul set/p"=!menu_inst[%%C]!")
							)
							echo !menu[%%g]:~-4,-1!|%systemroot%\system32\findstr.exe /x "exe">nul 2>&1 && (
								for /l %%J in (0,1,%idx%) do (
									%systemroot%\system32\findstr.exe /C:"!packers[%%J]!" !menu[%%g]! >nul 2>nul && (
										set nao_identificado=0
										start "" /b !menu[%%g]! !packers_switches[%%J]! && (
											<nul set/p"=[22;0H[1C"
											cmd /v:on /q /c "for /l %%B in () do (for /l %%T in (2,2,58) do (WMIC.exe PROCESS where "Name='!menu1[%%g]:~0,-36!'" get CommandLine 2>nul|findstr /c:!menu[%%g]!>nul && ( @echo|set/p"=[2G[1;48;5;94m.^^!barra_andamento:~0,%%T^^![m" & pathping -4 -h 1 -n -p 150 -q 2 -w 1 127.1 >nul ) || (set/p"=[1K[2G[38;5;242;1m!barra_andamento![m[2G"<nul & exit /b))) & set/p"=[1K[2G[38;5;242;1m!barra_andamento![m[2G"<nul"
											call set "menu_inst[!qtd_item!]=%%menu_inst[!qtd_item!]%%[4D[1;48;5;19m-  OK [m"
										) || (
											call set "menu_inst[!qtd_item!]=[1;38;5;166m%%menu_inst[!qtd_item!]%%[4D[1;38;5;166;48;5;19m- ERRO[m"
										)
									)
								)
							)
							echo !menu[%%g]:~-4,-1!|%systemroot%\system32\findstr.exe /x "msi" >nul 2>&1 && (
								set nao_identificado=0
								start "" /b msiexec /i !menu[%%g]! /qr /norestart >nul 2>nul && (
									<nul set/p"=[22;0H[1C"
									cmd /v:on /q /C "for /l %%B in () do (for /l %%T in (2,2,58) do (WMIC.exe PROCESS where "Name='msiexec.exe'" get CommandLine 2>nul|findstr /c:!menu[%%g]! >nul && (@echo|set/p"=[2G[1;48;5;94m.^^!barra_andamento:~0,%%T^^![m" & pathping -4 -h 1 -n -p 150 -q 2 -w 1 127.1 >nul ) || (set/p"=[1K[2G[38;5;242;1m!barra_andamento![m[2G"<nul & exit /b))) & set/p"=[1K[2G[38;5;242;1m!barra_andamento![m[2G"<nul"
									call set "menu_inst[!qtd_item!]=%%menu_inst[!qtd_item!]%%[4D[1;48;5;19m-  OK [m"
								) || (
									call set "menu_inst[!qtd_item!]=[1;38;5;166m%%menu_inst[!qtd_item!]%%[4D[1;38;5;166;48;5;19m- ERRO[m"
								)
							)
							echo !menu[%%g]:~-4,-1!|%systemroot%\system32\findstr.exe /x "lnk" >nul 2>&1 && (
								for %%Q in (atalho atalho_1 atalho_2) do set "%%Q="
								set nao_identificado=0
								start "" !menu[%%g]! >nul 2>nul && (
									<nul set/p"=[22;0H[1C"
									set "atalho=!menu[%%g]:"=!"
									for /f "tokens=2 delims==" %%I in ('wmic path win32_shortcutfile where "name='!atalho:\=\\!'" get target /value') do if not "%%I"=="" (for /f "delims=" %%# in ("%%~I") do set "atalho_1=%%#" & set "atalho_2=%%~nx#")
									cmd /v:on /q /c "for /l %%B in () do (for /l %%T in (2,2,58) do (WMIC.exe PROCESS where "Name='!atalho_2!'" get CommandLine 2>nul|findstr /c:"!atalho_1!" >nul && (@echo|set/p"=[2G[1;48;5;94m.^^!barra_andamento:~0,%%T^^![m" & pathping -4 -h 1 -n -p 150 -q 2 -w 1 127.1 >nul ) || (set/p"=[1K[2G[38;5;242;1m!barra_andamento![m[2G"<nul & exit /b))) & set/p"=[1K[2G[38;5;242;1m!barra_andamento![m[2G"<nul"
									call set "menu_inst[!qtd_item!]=%%menu_inst[!qtd_item!]%%[4D[1;48;5;19m-  OK [m"
								) || (
									call set "menu_inst[!qtd_item!]=[1;38;5;166m%%menu_inst[!qtd_item!]%%[4D[1;38;5;166;48;5;19m- ERRO[m"
								)
							)
						) 
						if !nao_identificado!==1 (
							if %%g leq %count% (
								call set "menu_inst[!qtd_item!]=[1;38;5;166m%%menu_inst[!qtd_item!]%%[4D[1;38;5;166;48;5;19m- NoID[m"				
							)
						)
					)
					<nul set/p"=[5;0H"
					for /l %%C in (!item_ini!,1,!qtd_item!) do (
						echo.
						if not "!menu_inst[%%C]!"=="" (<nul set/p"=!menu_inst[%%C]!")
					)
				)
			)
		)

	set qtd_it=!qtd_item!
	<nul set/p"=[22H[0m [38;5;214;1;3m+/-[38;5;242;1m=Acima/Abaixo      [97;1m−−− [38;5;214;1;23mFEITO [97;1m−−−           [38;5;214;1;3mEnter[38;5;242;1m=Voltar [m"

	:rolagem
		for /F "eol=0 delims=" %%N in ('xcopy /qw "%~f0" "%~f0" 2^>NUL') do (
			set "rol=%%N"
			set "rol=!rol:~-1!"
		)
		if "%rol%"=="+" (
			if !item_ini! gtr 1 (
				set /a item_ini-=1
				set /a qtd_it=!item_ini!+14
				<nul set/p"=[5;0H"
				for /l %%D in (!item_ini!,1,!qtd_it!) do (
					echo.
					if not "!menu_inst[%%D]!"=="" (<nul set/p"=!menu_inst[%%D]!")
				)
			)
			goto :rolagem
		)
		if "%rol%"=="-" (
			if !qtd_it! lss !qtd_item! (
				set /a item_ini+=1
				set /a qtd_it=!item_ini!+14
				<nul set/p"=[5;0H"
				for /l %%D in (!item_ini!,1,!qtd_it!) do (
					echo.
					if not "!menu_inst[%%D]!"=="" (<nul set/p"=!menu_inst[%%D]!")
				)
			)
			goto :rolagem
		)
		if "%rol%" neq "" (set "rol=" & goto :rolagem)
	goto :inicio

	:decida
	mode 60,5
	echo;
	echo;       Deseja prosseguir sem elevação administrativa?
	echo;	
	echo;                     (S)im ou (N)ão?  
		for /F "eol=0 delims=" %%L in ('xcopy /qw "%~f0" "%~f0" 2^>NUL') do (
			@REM set/p"=[?25l"<nul
			set "capt=%%L"
		)
		if /I "!capt:~-1!"=="S" (goto :prossiga)
		if /I "!capt:~-1!"=="N" (goto :escape)
	goto :decida

	:sem_pasta_arquivo
	mode 60,5
	echo;
	echo;[31;40;1m █▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█[m
	echo; [31;40;1m█[91m               %~1               [31;40;1m█[m
	pause>nul|echo;[31;40;1m █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█[m
	cls
	
	:escape
		if "%lines%"=="" set lines=1
	echo.[2J[!lines!;0H
	@REM set/p"=[100;0H[3;30;47m                            SAIR                            [m"<nul
		for /l %%A in (!lines!,-1,0) do (
			set/p"=[0F[2K[8;%%A;60t[3;30;47m                            SAIR                            [m"<nul
			pathping -4 -h 1 -n -p 5 -q 1 -w 1 127.1 >nul
		)
	set/p"=[?25h"<nul
	endlocal
	exit

	exit
	:tam_intervalo
	set "d_opc=%~1"
	:loop
		if "%d_opc:~21,1%" neq "" (set "%2=%d_opc%" & exit /b)
	set "d_opc=%d_opc% "
	goto :loop
	exit /b

	:instrucoes
	mode 60,21
	echo.[?25l
	set/p"=[2J"<nul
	title Instruções Rápidas
		for /l %%n in (1,1,!counta!) do (echo [1C[38;5;241;1m!menu0[%%n]!)
	<nul set /p"=[3H"
		for /l %%m in (1,1,!counto!) do (echo [3C[38;5;241;1;3m!sobremenu[%%m]![m)
	echo.

		for /l %%e in (1,1,16) do (echo. [47m                                                          [m)
	<nul set/p"=[16A[3G[1;38;5;251;48;5;0m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀[m"
	<nul set /p"=[1B[3G[1;38;5;231;48;5;0m                   INSTRUÇÕES RÁPIDAS                   [m"
	<nul set /p"=[1B[3G[1;38;5;251;48;5;0m▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄[m"
	<nul set /p"=[1B[9G[3;30;47m● Digite o nº da opção e confirme com [m[1;3;38;5;20;48;5;251mENTER[m[3;30;47m;"
	<nul set /p"=[1B[9G● São aceitos até 2 dígitos por opção;"
	<nul set /p"=[1B[9G● Para mais de um ítem, separe com [m[1;3;38;5;20;48;5;251mESPAÇOS[m[3;30;47m^!"
	<nul set /p"=[1B[9G● Para SAIR digite 00 e confirme com [m[1;3;38;5;20;48;5;251mENTER[m[3;30;47m^!"
	<nul set /p"=[1B[9G● Para prosseguir após um espaço, deve haver"
	<nul set /p"=[1B[9G  um número."
	<nul set /p"=[1B[9G● Faixas de opções podem ser aplicadas com "^-^"."
	<nul set /p"=[1B[9G  Ex: 1-10, seleciona as opções de 1 a 10."
	<nul set /p"=[1B[9G● Caso haja mais de 15 ítens para instalação, é"
	<nul set /p"=[1B[9G  possível rolar a tela através de "^+" e "^-"."
	<nul set /p"=[1B[3G[m[1;3;38;5;0;48;5;251m▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄[m"
	<nul set /p"=[1B[3G[m[1;3;38;5;157;48;5;0m      Para instalar todos, digite 1-(último ítem)^!      [m"
	<nul set /p"=[1B[3G[m[1;3;38;5;0;48;5;251m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀[m"
	<nul set /p"=[1B[19G[38;5;242;1mTECLE ALGO PARA VOLTAR^![m"
	pause>nul
	set/p"=[2J" <nul
	goto :sub_inicio