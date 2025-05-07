USE Rusia2018



------------------------
--EJERCICIO 1
CREATE PROCEDURE  sp_Ejercicio1 
					
AS
BEGIN
			SELECT t.nomTecnico AS Nombre_Tecnico 
			,t.nacionalidad AS Nacionalidada
			,YEAR(GETDATE())- YEAR(t.fechaNacimiento) AS Edad
			FROM Tecnico AS t
			WHERE YEAR(GETDATE())- YEAR(t.fechaNacimiento)= ( Select MAX(YEAR(GETDATE())- YEAR(tec.fechaNacimiento))
															 FROM Tecnico tec
															 WHERE tec.nacionalidad LIKE '%i%')      
END	

EXEC sp_Ejercicio1
-------------------------------------------------------------------------
--EJERCICIO 2
SELECT * FROM Tecnico
SELECT * FROM Continente
SELECT * FROM Pais


CREATE PROCEDURE  sp_Ejercicio2 
					
AS
BEGIN
			SELECT t.nomTecnico AS Nombre_Tecnico 
			,t.nacionalidad AS Nacionalidada
			,CONVERT(VARCHAR(10),t.fechaNacimiento,103) AS Fecha_nacimiento
			,c.descripcion AS Continente
			FROM Tecnico AS t
				INNER JOIN Pais p ON t.idTecnico=p.idTecnico
				INNER JOIN Continente c ON c.idContinente=p.idContinente
			WHERE YEAR(t.fechaNacimiento) < 1960 
			OR YEAR(t.fechaNacimiento) >1980
			ORDER BY YEAR(t.fechaNacimiento)
		
END	

EXEC sp_Ejercicio2
---------------------------------------------------------------
--EJERCICIO 3
CREATE PROCEDURE  sp_Ejercicio3
					
AS
BEGIN
	SELECT 
		nomEstadio AS Nombre_Estadio
		,aforo AS Aforo
		,ciudad AS Ubicacion
	FROM Estadio
	WHERE aforo >  (SELECT AVG(aforo)FROM Estadio)
END	

EXEC sp_Ejercicio3

SELECT AVG(aforo)	FROM Estadio

-------------------------------
--ejercicio 4

CREATE PROCEDURE  sp_Ejercicio4					ASBEGIN			SELECT 
			p.nomPais AS Nombre_Pais
			,j.posicion AS Posicion
			,COUNT(j.posicion) AS Total_Posicion
			FROM Jugador AS j
			INNER JOIN Pais p ON j.idPais = p.idPais
			WHERE j.posicion NOT IN (
						SELECT j2.posicion
						FROM Jugador AS j2
						WHERE j2.posicion ='Defensa' 
						OR j2.posicion ='Delantero'
						)			
				GROUP BY j.idPais, j.posicion,p.nomPais
				ORDER BY p.nomPais       END	EXEC sp_Ejercicio4---------------------------------------EJERCICIO 5CREATE PROCEDURE  sp_Ejercicio5 					@CONTINENTE_TECNICO AS VARCHAR(20)ASBEGIN			SELECT  t. nomTecnico AS Nombre_Tecnico					,t.nacionalidad AS Nacionalidad					,CONVERT(date,t.fechaNacimiento,103) AS Fecha_nacimiento					,c.descripcion AS Continente			FROM Tecnico t				INNER JOIN Pais p ON t.idTecnico=p.idTecnico				INNER JOIN Continente c ON c.idContinente=p.idContinente				WHERE  YEAR(t.fechaNacimiento) >1960 AND c.descripcion NOT IN(@CONTINENTE_TECNICO)END	select * from Paisselect * from Continente--PARA EJECUTARLOEXEC sp_Ejercicio5 'Europa'---------------------------------------------------EJERCICIO 6CREATE PROCEDURE  sp_Ejercicio6 					@CONTINENTE_J AS VARCHAR(20)ASBEGIN		SELECT 
			DISTINCT j.nomJugador AS Nombre_jugador
			,p.nomPais AS Nombre_Pais
			,c.descripcion AS Continente
			,CONVERT(date,el.fecha,103) AS Fecha_Encuentro_Local
			,f.descripcion AS Fase
			FROM Jugador AS j
			INNER JOIN Pais p ON j.idPais = p.idPais			INNER JOIN Continente c ON c.idContinente=p.idContinente			INNER JOIN Encuentro el ON el.idPaisL=j.idPais OR el.idPaisV=j.idPais			INNER JOIN Fase f ON f.idFase=el.idFase			WHERE f.descripcion = 'Fase de Grupos' 			AND c.descripcion = @CONTINENTE_J			ORDER BY p.nomPaisEND	EXEC sp_Ejercicio6 'Asia'--------------------------------------------------------------EJERCICIO 7CREATE PROCEDURE  sp_Ejercicio7					@Caracter_estadio AS VARCHAR(20)ASBEGIN		SELECT	
		 pl.nomPais AS Pais_Local
		 ,en.golesPaisL AS Goles_Pais_Local
		,pv.nomPais AS Pais_Visitante
		,en.golesPaisV AS Goles_Pais_Visitante
		,a.nomArbitro AS Nombre_Arbitro
		,e.nomEstadio AS Estadio
		,f.descripcion AS Fase
		FROM Encuentro en
			INNER JOIN Pais pL ON en.idPaisL = Pl.idPais
			INNER JOIN Pais pV ON en.idPaisV = pV.idPais
			INNER JOIN Fase f ON en.idFase = f.idFase
			INNER JOIN Arbitro a ON en.idArbitro = a.idArbitro
			INNER JOIN Estadio e ON en.idEstadio = e.idEstadio		WHERE f.descripcion = 'Fase de Grupos' 		AND e.nomEstadio LIKE '%'+@Caracter_estadio+'%'END	EXEC sp_Ejercicio7 'k'--------------------------------------------------------------EJERCICIO 8CREATE PROCEDURE  sp_Ejercicio8					@Nom_pais AS VARCHAR(20)ASBEGIN		SELECT		j.nomJugador AS Nombre_Jugador		,p.nomPais AS Pais		,COUNT(g.idJugador) AS Goles	 FROM Gol g	 INNER JOIN Jugador j ON j.idJugador=g.idJugador	 INNER JOIN Pais p ON p.idPais=j.idPais	 INNER JOIN Encuentro en ON en.idPaisL=p.idPais	 INNER JOIN Fase f ON f.idFase=en.idFase	 WHERE f.descripcion = 'Fase de Grupos' AND p.nomPais=@Nom_pais	 GROUP BY j.nomJugador,p.nomPais			END	EXEC sp_Ejercicio8 'México'--------------------------------------------------------------EJERCICIO 9CREATE PROCEDURE  sp_Ejercicio9					@Nombre_estadio AS VARCHAR(20)ASBEGIN		SELECT 		es.nomEstadio AS Estadio		,e.idEncuentro AS Encuentro		,e.golesPaisL+e.golesPaisV AS Goles		FROM Encuentro e		INNER JOIN Estadio es ON e.idEstadio=es.idEstadio		WHERE es.nomEstadio =@Nombre_estadioEND	select * from Encuentroselect * from EstadioEXEC sp_Ejercicio9 'Fisht'