-- Queries to look into Nintendo Switch Games

--#1 Looking at all the games sorted by it's rank
SELECT * FROM Nintendo..NinSwitchGames
Order by Position

--#2 Looking at games that were scored on VGChartz
SELECT * FROM Nintendo..NinSwitchGames
WHERE [VGChartz Score] IS NOT NULL
Order by [VGChartz Score] desc

--#3 Looking at Critic Scores
SELECT * FROM Nintendo..NinSwitchGames
WHERE [Critic Score] IS NOT NULL
Order by [Critic Score] desc

--#4 Looking at User Score
SELECT * FROM Nintendo..NinSwitchGames
WHERE [User Score] IS NOT NULL AND [User Score] != 'N/A'
Order by CAST([User Score] AS decimal(3,1)) desc


--#5 Looking at the most shipped games
SELECT Position, Game, Publisher, Developer, [Release Date], [Last Update],
	(
	  SELECT TRIM('m' FROM [Total Shipped])
	) AS TotalShippedMillions
FROM Nintendo..NinSwitchGames
WHERE [Total Shipped] != 'N/A'
ORDER BY TRY_CAST([Total Shipped] AS DECIMAL(5,2)) desc


--#6 Looking at publisher average position ranking (position is determined by total sales)
SELECT Publisher, CAST(AVG(Position) AS int) AS AvgPosition
FROM Nintendo..NinSwitchGames
GROUP BY Publisher
ORDER BY AvgPosition asc


--#7 Looking at developer average position ranking (position is determined by total sales)
SELECT Developer, CAST(AVG(Position) AS int) AS AvgPosition
FROM Nintendo..NinSwitchGames
GROUP BY Developer
ORDER BY AvgPosition asc


--#8 Looking at average VGChartz per publisher
SELECT Publisher, CAST(AVG([VGChartz Score]) AS decimal(4,1)) AS VGChartz
FROM Nintendo..NinSwitchGames
WHERE [VGChartz Score] IS NOT NULL
GROUP BY Publisher
ORDER BY VGChartz desc


--#9 Looking at average Critic Score per publisher
SELECT Publisher, CAST(AVG([Critic Score]) AS decimal(4,1)) AS CriticScore
FROM Nintendo..NinSwitchGames
WHERE [Critic Score] IS NOT NULL
GROUP BY Publisher
ORDER BY CriticScore desc

--#10 Looking at average User Score per publisher
SELECT Publisher, AVG(CAST([User Score] AS DECIMAL(4,1))) AS UserScore
FROM Nintendo..NinSwitchGames
WHERE [User Score] IS NOT NULL AND [User Score] != 'N/A'
GROUP BY Publisher
ORDER BY UserScore desc


--#11 Looking at average VGChartz per developer
SELECT Developer, CAST(AVG([VGChartz Score]) AS decimal(4,1)) AS VGChartz
FROM Nintendo..NinSwitchGames
WHERE [VGChartz Score] IS NOT NULL
GROUP BY Developer
ORDER BY VGChartz desc


--#12 Looking at average Critic Score per Developer
SELECT Developer, CAST(AVG([Critic Score]) AS decimal(4,1)) AS CriticScore
FROM Nintendo..NinSwitchGames
WHERE [Critic Score] IS NOT NULL
GROUP BY Developer
ORDER BY CriticScore desc


--#13 Looking at average User Score per Developer
SELECT Developer, AVG(CAST([User Score] AS DECIMAL(4,1))) AS UserScore
FROM Nintendo..NinSwitchGames
WHERE [User Score] IS NOT NULL AND [User Score] != 'N/A'
GROUP BY Developer
ORDER BY UserScore desc
