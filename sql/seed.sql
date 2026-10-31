-- Sample data for novel_portal. Import after schema.sql.
-- Logins: admin / admin123, alice / password123, bob / password123, chen / password123
-- Dates are relative to NOW() so Trending and Recently Updated look fresh whenever this is imported.
USE novel_portal;

INSERT INTO users (username, email, password_hash, role, created_at) VALUES
('admin', 'admin@localhost', '$2y$10$.klJI4EzFogPIk7GCeyskuZ6BMnd2A5lETXIt8JTff39Kdp9Ne4jK', 'admin', NOW() - INTERVAL 90 DAY),
('alice', 'alice@localhost', '$2y$10$I79iEMeMnPGMizHVx/tkCeIj9NFhVL1kKgUTSTsI8hZI3KU9eaSiS', 'member', NOW() - INTERVAL 90 DAY),
('bob', 'bob@localhost', '$2y$10$KxgzysSLnI.M1eXPZ/ngEen0GNrGtwICit.WQeilVmbPwDTEk5lUi', 'member', NOW() - INTERVAL 90 DAY),
('chen', 'chen@localhost', '$2y$10$Obmnh9gDwUXsZS1z4IXzQOXg.z.zxtX.pTPg/z6Hzn5rvIesxSUGm', 'member', NOW() - INTERVAL 90 DAY),
('inkwell', 'inkwell@localhost', '$2y$10$qED/SGAsemgDsCSvkvnQ5ui7R1rEXFsbmNV4SBO6zn.e.6TP3zK9O', 'member', NOW() - INTERVAL 90 DAY);

INSERT INTO genres (name, slug) VALUES
('Fantasy', 'fantasy'),
('Action', 'action'),
('Romance', 'romance'),
('Adventure', 'adventure'),
('Mystery', 'mystery'),
('Sci-Fi', 'sci-fi'),
('System', 'system'),
('Horror', 'horror'),
('Comedy', 'comedy'),
('Slice of Life', 'slice-of-life');

INSERT INTO tags (name) VALUES
('Magic'),
('Reincarnation'),
('Female Lead'),
('Male Lead'),
('Cultivation'),
('Dungeon'),
('Slow Burn'),
('Revenge'),
('Found Family'),
('Time Travel'),
('Detective'),
('Space'),
('Cozy'),
('Dark'),
('Academy'),
('Royalty');

INSERT INTO books (serial_no, title, user_id, genre_id, language, synopsis, cover, status, price, views, created_at) VALUES
('NB-000001', 'The Last Lantern', 5, 1, 'English', 'When every light in the kingdom goes out, a lamplighter''s apprentice discovers she carries the last flame that can rekindle them, and every faction wants it.', NULL, 'ongoing', 4.99, 27400000, NOW() - INTERVAL 100 DAY),
('NB-000002', 'Iron Tide', 3, 2, 'English', 'A disgraced naval officer returns to the sea at the helm of a stolen warship, hunting the admiral who sank his fleet.', NULL, 'ongoing', 5.99, 15200000, NOW() - INTERVAL 97 DAY),
('NB-000003', 'Letters to Autumn', 4, 3, 'English', 'Two strangers swap letters through a library book left on the same shelf, never knowing they live on the same street.', NULL, 'completed', 3.99, 9800000, NOW() - INTERVAL 94 DAY),
('NB-000004', 'The Clockmaker''s Secret', 5, 5, 'English', 'A clockmaker is found dead inside a locked tower, and every clock in the city has stopped at the same minute.', NULL, 'completed', 4.49, 6100000, NOW() - INTERVAL 91 DAY),
('NB-000005', 'Starbound', 2, 6, 'English', 'The crew of a salvage freighter answers a distress call from a ship that disappeared three hundred years ago.', NULL, 'ongoing', 5.49, 4400000, NOW() - INTERVAL 88 DAY),
('NB-000006', 'Ashen Crown', 3, 4, 'English', 'A runaway prince crosses the burnt wastes to reclaim a crown that turns to ash in the hands of anyone unworthy.', NULL, 'ongoing', 4.99, 2900000, NOW() - INTERVAL 85 DAY),
('NB-000007', 'Whispering Pines', 4, 8, 'English', 'Campers at a lakeside retreat begin to hear their own voices calling from the forest at night.', NULL, 'completed', 2.99, 1700000, NOW() - INTERVAL 82 DAY),
('NB-000008', 'System Restart', 2, 7, 'English', 'A burnt-out programmer wakes up inside the game he was fired from, and the admin console still answers to him.', NULL, 'ongoing', 3.49, 980500, NOW() - INTERVAL 79 DAY),
('NB-000009', 'The Sword Saint Who Refused to Retire', 5, 2, 'English', 'At ninety, the empire''s greatest swordsman is told to step aside. He opens a dojo instead, for the students nobody else will train.', NULL, 'ongoing', 4.99, 642300, NOW() - INTERVAL 76 DAY),
('NB-000010', 'Moonlit Bakery', 4, 10, 'English', 'A bakery that only opens after midnight serves pastries that let customers relive one good memory.', NULL, 'ongoing', 1.99, 410800, NOW() - INTERVAL 73 DAY),
('NB-000011', 'Dungeon Diner', 2, 9, 'English', 'An ex-adventurer opens a restaurant on the fifth floor of a dungeon. The monsters become her best customers.', NULL, 'ongoing', 2.49, 355000, NOW() - INTERVAL 70 DAY),
('NB-000012', 'Echoes of Atlantis', 3, 4, 'English', 'A marine archaeologist finds a door on the sea floor that opens onto a city still very much alive.', NULL, 'completed', 4.99, 298000, NOW() - INTERVAL 67 DAY),
('NB-000013', 'Academy of Thorns', 5, 1, 'English', 'The only student without magic at a school for mages must survive a year of duels by being cleverer than everyone else.', NULL, 'ongoing', 3.99, 254000, NOW() - INTERVAL 64 DAY),
('NB-000014', 'Neon Detective', 2, 5, 'English', 'In a city where memories can be bought, a detective investigates a murder that nobody can remember.', NULL, 'ongoing', 3.49, 199000, NOW() - INTERVAL 61 DAY),
('NB-000015', 'Second Chance Empress', 4, 3, 'English', 'Betrayed and executed, the empress wakes up ten years in the past, determined to rewrite every mistake.', NULL, 'completed', 5.99, 187000, NOW() - INTERVAL 58 DAY),
('NB-000016', 'The Quiet Apocalypse', 3, 8, 'English', 'One morning everyone in the city falls asleep except twelve people, and the sleepers have started to sleepwalk.', NULL, 'ongoing', 2.99, 143000, NOW() - INTERVAL 55 DAY),
('NB-000017', 'Level One Farmer', 5, 7, 'English', 'Given the weakest class in a world of heroes, a young farmer discovers that crops can level up too.', NULL, 'ongoing', 2.49, 121000, NOW() - INTERVAL 52 DAY),
('NB-000018', 'Paper Moons', 4, 10, 'English', 'A retired teacher and her teenage neighbour rebuild a run-down bookshop one shelf at a time.', NULL, 'completed', 1.49, 96000, NOW() - INTERVAL 49 DAY),
('NB-000019', 'Gravity''s Edge', 2, 6, 'English', 'A pilot stranded at the edge of a black hole has to decide whether to save her crew or the colony that abandoned them.', NULL, 'ongoing', 4.49, 78000, NOW() - INTERVAL 46 DAY),
('NB-000020', 'My Roommate Is a Dragon', 3, 9, 'English', 'A broke university student rents a cheap room, then learns the landlord is a dragon who is very bad at being human.', NULL, 'ongoing', 1.99, 54000, NOW() - INTERVAL 43 DAY);

INSERT INTO book_tags (book_id, tag_id) VALUES
(1, 1),
(1, 3),
(1, 14),
(2, 4),
(2, 8),
(3, 7),
(3, 3),
(3, 13),
(4, 11),
(4, 10),
(5, 12),
(5, 9),
(6, 16),
(6, 8),
(6, 4),
(7, 14),
(7, 11),
(8, 2),
(8, 6),
(8, 4),
(9, 5),
(9, 4),
(9, 9),
(10, 13),
(10, 9),
(10, 3),
(11, 6),
(11, 13),
(12, 10),
(12, 9),
(13, 15),
(13, 1),
(13, 3),
(14, 11),
(14, 12),
(14, 14),
(15, 2),
(15, 16),
(15, 8),
(15, 3),
(16, 14),
(16, 9),
(17, 6),
(17, 13),
(17, 4),
(18, 13),
(18, 7),
(19, 12),
(19, 8),
(20, 1),
(20, 9),
(20, 13);

INSERT INTO chapters (book_id, number, title, content, created_at) VALUES
(1, 1, 'A Strange Beginning', 'Nobody had warned them that the road would end like this. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

The candle burned lower, and with it went the last of their patience. The old stories had always said the gate would open on its own. They had never said what would walk through it. Every choice had a price. The trick was knowing who would pay it.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Footsteps echoed somewhere behind the wall, too regular to be the wind. "You knew," she whispered. "You knew all along and you said nothing."

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Somewhere far off, a clock struck a time that did not exist. They walked in silence until the lights of the next town appeared through the trees.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Every choice had a price. The trick was knowing who would pay it.

He smiled for the first time that day.', NOW() - INTERVAL 571 HOUR),
(1, 2, 'The First Step', 'Nobody had warned them that the road would end like this. The candle burned lower, and with it went the last of their patience.

They walked in silence until the lights of the next town appeared through the trees. Footsteps echoed somewhere behind the wall, too regular to be the wind. The candle burned lower, and with it went the last of their patience.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

The old stories had always said the gate would open on its own. They had never said what would walk through it. They walked in silence until the lights of the next town appeared through the trees. "We do this my way," he said, though his voice shook more than he wanted it to.

Somewhere far off, a clock struck a time that did not exist. The old stories had always said the gate would open on its own. They had never said what would walk through it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The old stories had always said the gate would open on its own. They had never said what would walk through it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

And then, very quietly, the door began to open.', NOW() - INTERVAL 523 HOUR),
(1, 3, 'Unexpected Guests', 'The morning came slowly, grey light pooling at the edges of the window. "You knew," she whispered. "You knew all along and you said nothing."

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Footsteps echoed somewhere behind the wall, too regular to be the wind.

The old stories had always said the gate would open on its own. They had never said what would walk through it. "You knew," she whispered. "You knew all along and you said nothing." Every choice had a price. The trick was knowing who would pay it.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. They walked in silence until the lights of the next town appeared through the trees. "You knew," she whispered. "You knew all along and you said nothing."

Every choice had a price. The trick was knowing who would pay it. "We do this my way," he said, though his voice shook more than he wanted it to. "You knew," she whispered. "You knew all along and you said nothing."

Somewhere far off, a clock struck a time that did not exist. Every choice had a price. The trick was knowing who would pay it. A notice flickered into view, glowing faintly in the air in front of them.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 475 HOUR),
(1, 4, 'Into the Dark', 'It had been raining for nine days when the stranger arrived. The old stories had always said the gate would open on its own. They had never said what would walk through it.

They walked in silence until the lights of the next town appeared through the trees. They walked in silence until the lights of the next town appeared through the trees. The candle burned lower, and with it went the last of their patience.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. They walked in silence until the lights of the next town appeared through the trees. A notice flickered into view, glowing faintly in the air in front of them.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "We do this my way," he said, though his voice shook more than he wanted it to. They walked in silence until the lights of the next town appeared through the trees.

"You knew," she whispered. "You knew all along and you said nothing." There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "You knew," she whispered. "You knew all along and you said nothing."

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 427 HOUR),
(1, 5, 'Old Promises', 'Nobody had warned them that the road would end like this. The old stories had always said the gate would open on its own. They had never said what would walk through it.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Every choice had a price. The trick was knowing who would pay it. A notice flickered into view, glowing faintly in the air in front of them.

They walked in silence until the lights of the next town appeared through the trees. The candle burned lower, and with it went the last of their patience. They walked in silence until the lights of the next town appeared through the trees.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Somewhere far off, a clock struck a time that did not exist. They walked in silence until the lights of the next town appeared through the trees.

The candle burned lower, and with it went the last of their patience. A notice flickered into view, glowing faintly in the air in front of them. They walked in silence until the lights of the next town appeared through the trees.

Footsteps echoed somewhere behind the wall, too regular to be the wind. Every choice had a price. The trick was knowing who would pay it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 379 HOUR),
(1, 6, 'The Long Night', 'For the first time in years, the city was completely silent. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

They walked in silence until the lights of the next town appeared through the trees. The old stories had always said the gate would open on its own. They had never said what would walk through it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

The candle burned lower, and with it went the last of their patience. A notice flickered into view, glowing faintly in the air in front of them. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Every choice had a price. The trick was knowing who would pay it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. A notice flickered into view, glowing faintly in the air in front of them.

"We do this my way," he said, though his voice shook more than he wanted it to. A notice flickered into view, glowing faintly in the air in front of them. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. The candle burned lower, and with it went the last of their patience. They walked in silence until the lights of the next town appeared through the trees.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 331 HOUR),
(1, 7, 'Broken Rules', 'Nobody had warned them that the road would end like this. "We do this my way," he said, though his voice shook more than he wanted it to.

They walked in silence until the lights of the next town appeared through the trees. They walked in silence until the lights of the next town appeared through the trees. "We do this my way," he said, though his voice shook more than he wanted it to.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. They walked in silence until the lights of the next town appeared through the trees.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. The old stories had always said the gate would open on its own. They had never said what would walk through it. Somewhere far off, a clock struck a time that did not exist.

Footsteps echoed somewhere behind the wall, too regular to be the wind. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The old stories had always said the gate would open on its own. They had never said what would walk through it.

And then, very quietly, the door began to open.', NOW() - INTERVAL 283 HOUR),
(1, 8, 'A Familiar Face', 'The morning came slowly, grey light pooling at the edges of the window. Footsteps echoed somewhere behind the wall, too regular to be the wind.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "We do this my way," he said, though his voice shook more than he wanted it to.

Every choice had a price. The trick was knowing who would pay it. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The candle burned lower, and with it went the last of their patience.

Footsteps echoed somewhere behind the wall, too regular to be the wind. Somewhere far off, a clock struck a time that did not exist. "You knew," she whispered. "You knew all along and you said nothing."

"We do this my way," he said, though his voice shook more than he wanted it to. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. They walked in silence until the lights of the next town appeared through the trees. The old stories had always said the gate would open on its own. They had never said what would walk through it.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 235 HOUR),
(1, 9, 'Crossroads', 'The bell rang three times before anyone dared to answer it. Somewhere far off, a clock struck a time that did not exist.

"We do this my way," he said, though his voice shook more than he wanted it to. The old stories had always said the gate would open on its own. They had never said what would walk through it. A notice flickered into view, glowing faintly in the air in front of them.

"We do this my way," he said, though his voice shook more than he wanted it to. The old stories had always said the gate would open on its own. They had never said what would walk through it. Somewhere far off, a clock struck a time that did not exist.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Footsteps echoed somewhere behind the wall, too regular to be the wind. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

The candle burned lower, and with it went the last of their patience. A notice flickered into view, glowing faintly in the air in front of them. Footsteps echoed somewhere behind the wall, too regular to be the wind.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Footsteps echoed somewhere behind the wall, too regular to be the wind. "We do this my way," he said, though his voice shook more than he wanted it to.

It was only the beginning.', NOW() - INTERVAL 187 HOUR),
(1, 10, 'Fire and Rain', 'For the first time in years, the city was completely silent. They walked in silence until the lights of the next town appeared through the trees.

They walked in silence until the lights of the next town appeared through the trees. They walked in silence until the lights of the next town appeared through the trees. Somewhere far off, a clock struck a time that did not exist.

The old stories had always said the gate would open on its own. They had never said what would walk through it. A notice flickered into view, glowing faintly in the air in front of them. "You knew," she whispered. "You knew all along and you said nothing."

Every choice had a price. The trick was knowing who would pay it. The candle burned lower, and with it went the last of their patience. "You knew," she whispered. "You knew all along and you said nothing."

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. The candle burned lower, and with it went the last of their patience. Somewhere far off, a clock struck a time that did not exist.

Footsteps echoed somewhere behind the wall, too regular to be the wind. Somewhere far off, a clock struck a time that did not exist. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

He smiled for the first time that day.', NOW() - INTERVAL 139 HOUR),
(1, 11, 'What Was Lost', 'The morning came slowly, grey light pooling at the edges of the window. They walked in silence until the lights of the next town appeared through the trees.

They walked in silence until the lights of the next town appeared through the trees. The candle burned lower, and with it went the last of their patience. The old stories had always said the gate would open on its own. They had never said what would walk through it.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. A notice flickered into view, glowing faintly in the air in front of them.

Somewhere far off, a clock struck a time that did not exist. "You knew," she whispered. "You knew all along and you said nothing." There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

They walked in silence until the lights of the next town appeared through the trees. "We do this my way," he said, though his voice shook more than he wanted it to. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

"You knew," she whispered. "You knew all along and you said nothing." Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "You knew," she whispered. "You knew all along and you said nothing."

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 91 HOUR),
(1, 12, 'The Turning Point', 'For the first time in years, the city was completely silent. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

They walked in silence until the lights of the next town appeared through the trees. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "You knew," she whispered. "You knew all along and you said nothing."

The old stories had always said the gate would open on its own. They had never said what would walk through it. Footsteps echoed somewhere behind the wall, too regular to be the wind. Somewhere far off, a clock struck a time that did not exist.

Somewhere far off, a clock struck a time that did not exist. "You knew," she whispered. "You knew all along and you said nothing." "We do this my way," he said, though his voice shook more than he wanted it to.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. The old stories had always said the gate would open on its own. They had never said what would walk through it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. They walked in silence until the lights of the next town appeared through the trees. The old stories had always said the gate would open on its own. They had never said what would walk through it.

And then, very quietly, the door began to open.', NOW() - INTERVAL 43 HOUR),
(2, 1, 'A Strange Beginning', 'It had been raining for nine days when the stranger arrived. Somewhere far off, a clock struck a time that did not exist.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. The candle burned lower, and with it went the last of their patience. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

The candle burned lower, and with it went the last of their patience. They walked in silence until the lights of the next town appeared through the trees. A notice flickered into view, glowing faintly in the air in front of them.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "You knew," she whispered. "You knew all along and you said nothing." Somewhere far off, a clock struck a time that did not exist.

A notice flickered into view, glowing faintly in the air in front of them. "You knew," she whispered. "You knew all along and you said nothing." The old stories had always said the gate would open on its own. They had never said what would walk through it.

Footsteps echoed somewhere behind the wall, too regular to be the wind. Somewhere far off, a clock struck a time that did not exist. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 323 HOUR),
(2, 2, 'The First Step', 'The morning came slowly, grey light pooling at the edges of the window. Footsteps echoed somewhere behind the wall, too regular to be the wind.

They walked in silence until the lights of the next town appeared through the trees. Every choice had a price. The trick was knowing who would pay it. The old stories had always said the gate would open on its own. They had never said what would walk through it.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Somewhere far off, a clock struck a time that did not exist. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. The old stories had always said the gate would open on its own. They had never said what would walk through it. "We do this my way," he said, though his voice shook more than he wanted it to.

They walked in silence until the lights of the next town appeared through the trees. They walked in silence until the lights of the next town appeared through the trees. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Every choice had a price. The trick was knowing who would pay it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 275 HOUR),
(2, 3, 'Unexpected Guests', 'The bell rang three times before anyone dared to answer it. Somewhere far off, a clock struck a time that did not exist.

Every choice had a price. The trick was knowing who would pay it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "You knew," she whispered. "You knew all along and you said nothing."

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. The old stories had always said the gate would open on its own. They had never said what would walk through it. Every choice had a price. The trick was knowing who would pay it.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. A notice flickered into view, glowing faintly in the air in front of them. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Somewhere far off, a clock struck a time that did not exist. "We do this my way," he said, though his voice shook more than he wanted it to.

He smiled for the first time that day.', NOW() - INTERVAL 227 HOUR),
(2, 4, 'Into the Dark', 'The bell rang three times before anyone dared to answer it. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

A notice flickered into view, glowing faintly in the air in front of them. They walked in silence until the lights of the next town appeared through the trees. Somewhere far off, a clock struck a time that did not exist.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Somewhere far off, a clock struck a time that did not exist. The candle burned lower, and with it went the last of their patience.

A notice flickered into view, glowing faintly in the air in front of them. "We do this my way," he said, though his voice shook more than he wanted it to. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "You knew," she whispered. "You knew all along and you said nothing."

"We do this my way," he said, though his voice shook more than he wanted it to. "You knew," she whispered. "You knew all along and you said nothing." Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 179 HOUR),
(2, 5, 'Old Promises', 'For the first time in years, the city was completely silent. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Somewhere far off, a clock struck a time that did not exist. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Every choice had a price. The trick was knowing who would pay it. The old stories had always said the gate would open on its own. They had never said what would walk through it. They walked in silence until the lights of the next town appeared through the trees.

A notice flickered into view, glowing faintly in the air in front of them. Footsteps echoed somewhere behind the wall, too regular to be the wind. The old stories had always said the gate would open on its own. They had never said what would walk through it.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. A notice flickered into view, glowing faintly in the air in front of them. Every choice had a price. The trick was knowing who would pay it.

The candle burned lower, and with it went the last of their patience. The old stories had always said the gate would open on its own. They had never said what would walk through it. They walked in silence until the lights of the next town appeared through the trees.

He smiled for the first time that day.', NOW() - INTERVAL 131 HOUR),
(2, 6, 'The Long Night', 'It had been raining for nine days when the stranger arrived. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Footsteps echoed somewhere behind the wall, too regular to be the wind. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Footsteps echoed somewhere behind the wall, too regular to be the wind. "You knew," she whispered. "You knew all along and you said nothing." The candle burned lower, and with it went the last of their patience.

"You knew," she whispered. "You knew all along and you said nothing." Every choice had a price. The trick was knowing who would pay it. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Footsteps echoed somewhere behind the wall, too regular to be the wind. The candle burned lower, and with it went the last of their patience. "You knew," she whispered. "You knew all along and you said nothing."

Somewhere far off, a clock struck a time that did not exist. The candle burned lower, and with it went the last of their patience. They walked in silence until the lights of the next town appeared through the trees.

And then, very quietly, the door began to open.', NOW() - INTERVAL 83 HOUR),
(2, 7, 'Broken Rules', 'The morning came slowly, grey light pooling at the edges of the window. "We do this my way," he said, though his voice shook more than he wanted it to.

Somewhere far off, a clock struck a time that did not exist. Footsteps echoed somewhere behind the wall, too regular to be the wind. "You knew," she whispered. "You knew all along and you said nothing."

The old stories had always said the gate would open on its own. They had never said what would walk through it. "You knew," she whispered. "You knew all along and you said nothing." Footsteps echoed somewhere behind the wall, too regular to be the wind.

"You knew," she whispered. "You knew all along and you said nothing." "You knew," she whispered. "You knew all along and you said nothing." She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

"You knew," she whispered. "You knew all along and you said nothing." There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "We do this my way," he said, though his voice shook more than he wanted it to. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

It was only the beginning.', NOW() - INTERVAL 35 HOUR),
(3, 1, 'A Strange Beginning', 'The morning came slowly, grey light pooling at the edges of the window. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Footsteps echoed somewhere behind the wall, too regular to be the wind. Somewhere far off, a clock struck a time that did not exist. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Footsteps echoed somewhere behind the wall, too regular to be the wind. "You knew," she whispered. "You knew all along and you said nothing." "You knew," she whispered. "You knew all along and you said nothing."

Footsteps echoed somewhere behind the wall, too regular to be the wind. Somewhere far off, a clock struck a time that did not exist. Every choice had a price. The trick was knowing who would pay it.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "You knew," she whispered. "You knew all along and you said nothing." "You knew," she whispered. "You knew all along and you said nothing."

They walked in silence until the lights of the next town appeared through the trees. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

It was only the beginning.', NOW() - INTERVAL 457 HOUR),
(3, 2, 'The First Step', 'For the first time in years, the city was completely silent. Every choice had a price. The trick was knowing who would pay it.

Footsteps echoed somewhere behind the wall, too regular to be the wind. Somewhere far off, a clock struck a time that did not exist. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Footsteps echoed somewhere behind the wall, too regular to be the wind. "You knew," she whispered. "You knew all along and you said nothing." The old stories had always said the gate would open on its own. They had never said what would walk through it.

A notice flickered into view, glowing faintly in the air in front of them. A notice flickered into view, glowing faintly in the air in front of them. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

The candle burned lower, and with it went the last of their patience. "You knew," she whispered. "You knew all along and you said nothing." Every choice had a price. The trick was knowing who would pay it.

They walked in silence until the lights of the next town appeared through the trees. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Every choice had a price. The trick was knowing who would pay it.

It was only the beginning.', NOW() - INTERVAL 409 HOUR),
(3, 3, 'Unexpected Guests', 'For the first time in years, the city was completely silent. The candle burned lower, and with it went the last of their patience.

The old stories had always said the gate would open on its own. They had never said what would walk through it. The candle burned lower, and with it went the last of their patience. They walked in silence until the lights of the next town appeared through the trees.

The old stories had always said the gate would open on its own. They had never said what would walk through it. The candle burned lower, and with it went the last of their patience. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Footsteps echoed somewhere behind the wall, too regular to be the wind. The candle burned lower, and with it went the last of their patience. A notice flickered into view, glowing faintly in the air in front of them.

They walked in silence until the lights of the next town appeared through the trees. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "You knew," she whispered. "You knew all along and you said nothing."

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. They walked in silence until the lights of the next town appeared through the trees. They walked in silence until the lights of the next town appeared through the trees.

And then, very quietly, the door began to open.', NOW() - INTERVAL 361 HOUR),
(3, 4, 'Into the Dark', 'The bell rang three times before anyone dared to answer it. The candle burned lower, and with it went the last of their patience.

They walked in silence until the lights of the next town appeared through the trees. Footsteps echoed somewhere behind the wall, too regular to be the wind. The candle burned lower, and with it went the last of their patience.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Somewhere far off, a clock struck a time that did not exist. "You knew," she whispered. "You knew all along and you said nothing."

The old stories had always said the gate would open on its own. They had never said what would walk through it. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Somewhere far off, a clock struck a time that did not exist.

The old stories had always said the gate would open on its own. They had never said what would walk through it. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "You knew," she whispered. "You knew all along and you said nothing."

Somewhere far off, a clock struck a time that did not exist. "You knew," she whispered. "You knew all along and you said nothing." Somewhere far off, a clock struck a time that did not exist.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 313 HOUR),
(3, 5, 'Old Promises', 'The bell rang three times before anyone dared to answer it. "You knew," she whispered. "You knew all along and you said nothing."

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "You knew," she whispered. "You knew all along and you said nothing." "We do this my way," he said, though his voice shook more than he wanted it to.

The candle burned lower, and with it went the last of their patience. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Footsteps echoed somewhere behind the wall, too regular to be the wind. A notice flickered into view, glowing faintly in the air in front of them.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Footsteps echoed somewhere behind the wall, too regular to be the wind.

Somewhere far off, a clock struck a time that did not exist. Footsteps echoed somewhere behind the wall, too regular to be the wind. Footsteps echoed somewhere behind the wall, too regular to be the wind.

He smiled for the first time that day.', NOW() - INTERVAL 265 HOUR),
(3, 6, 'The Long Night', 'Nobody had warned them that the road would end like this. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

"You knew," she whispered. "You knew all along and you said nothing." The old stories had always said the gate would open on its own. They had never said what would walk through it. They walked in silence until the lights of the next town appeared through the trees.

They walked in silence until the lights of the next town appeared through the trees. "We do this my way," he said, though his voice shook more than he wanted it to. "We do this my way," he said, though his voice shook more than he wanted it to.

"You knew," she whispered. "You knew all along and you said nothing." Somewhere far off, a clock struck a time that did not exist. "You knew," she whispered. "You knew all along and you said nothing."

Footsteps echoed somewhere behind the wall, too regular to be the wind. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

They walked in silence until the lights of the next town appeared through the trees. A notice flickered into view, glowing faintly in the air in front of them. The candle burned lower, and with it went the last of their patience.

And then, very quietly, the door began to open.', NOW() - INTERVAL 217 HOUR),
(3, 7, 'Broken Rules', 'The morning came slowly, grey light pooling at the edges of the window. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Somewhere far off, a clock struck a time that did not exist. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Footsteps echoed somewhere behind the wall, too regular to be the wind. "You knew," she whispered. "You knew all along and you said nothing."

Somewhere far off, a clock struck a time that did not exist. "We do this my way," he said, though his voice shook more than he wanted it to. Somewhere far off, a clock struck a time that did not exist.

Every choice had a price. The trick was knowing who would pay it. "We do this my way," he said, though his voice shook more than he wanted it to. A notice flickered into view, glowing faintly in the air in front of them.

The candle burned lower, and with it went the last of their patience. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. They walked in silence until the lights of the next town appeared through the trees.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 169 HOUR),
(3, 8, 'A Familiar Face', 'The morning came slowly, grey light pooling at the edges of the window. A notice flickered into view, glowing faintly in the air in front of them.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. The old stories had always said the gate would open on its own. They had never said what would walk through it. Somewhere far off, a clock struck a time that did not exist.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Somewhere far off, a clock struck a time that did not exist. "We do this my way," he said, though his voice shook more than he wanted it to.

A notice flickered into view, glowing faintly in the air in front of them. "You knew," she whispered. "You knew all along and you said nothing." Every choice had a price. The trick was knowing who would pay it.

A notice flickered into view, glowing faintly in the air in front of them. "You knew," she whispered. "You knew all along and you said nothing." Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Every choice had a price. The trick was knowing who would pay it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Every choice had a price. The trick was knowing who would pay it.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 121 HOUR),
(3, 9, 'Crossroads', 'The morning came slowly, grey light pooling at the edges of the window. "We do this my way," he said, though his voice shook more than he wanted it to.

Every choice had a price. The trick was knowing who would pay it. A notice flickered into view, glowing faintly in the air in front of them. Somewhere far off, a clock struck a time that did not exist.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "You knew," she whispered. "You knew all along and you said nothing." She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "We do this my way," he said, though his voice shook more than he wanted it to. Somewhere far off, a clock struck a time that did not exist.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Every choice had a price. The trick was knowing who would pay it. Footsteps echoed somewhere behind the wall, too regular to be the wind.

"We do this my way," he said, though his voice shook more than he wanted it to. Footsteps echoed somewhere behind the wall, too regular to be the wind. Every choice had a price. The trick was knowing who would pay it.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 73 HOUR),
(4, 1, 'A Strange Beginning', 'Nobody had warned them that the road would end like this. "You knew," she whispered. "You knew all along and you said nothing."

A notice flickered into view, glowing faintly in the air in front of them. "You knew," she whispered. "You knew all along and you said nothing." "We do this my way," he said, though his voice shook more than he wanted it to.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Somewhere far off, a clock struck a time that did not exist. A notice flickered into view, glowing faintly in the air in front of them.

"You knew," she whispered. "You knew all along and you said nothing." She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The candle burned lower, and with it went the last of their patience.

The candle burned lower, and with it went the last of their patience. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. The candle burned lower, and with it went the last of their patience.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The old stories had always said the gate would open on its own. They had never said what would walk through it. "We do this my way," he said, though his voice shook more than he wanted it to.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 354 HOUR),
(4, 2, 'The First Step', 'It had been raining for nine days when the stranger arrived. Somewhere far off, a clock struck a time that did not exist.

Every choice had a price. The trick was knowing who would pay it. "We do this my way," he said, though his voice shook more than he wanted it to. "We do this my way," he said, though his voice shook more than he wanted it to.

"We do this my way," he said, though his voice shook more than he wanted it to. They walked in silence until the lights of the next town appeared through the trees. "You knew," she whispered. "You knew all along and you said nothing."

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "We do this my way," he said, though his voice shook more than he wanted it to. A notice flickered into view, glowing faintly in the air in front of them.

A notice flickered into view, glowing faintly in the air in front of them. "You knew," she whispered. "You knew all along and you said nothing." Somewhere far off, a clock struck a time that did not exist.

The old stories had always said the gate would open on its own. They had never said what would walk through it. "We do this my way," he said, though his voice shook more than he wanted it to. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 306 HOUR),
(4, 3, 'Unexpected Guests', 'The bell rang three times before anyone dared to answer it. Every choice had a price. The trick was knowing who would pay it.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Footsteps echoed somewhere behind the wall, too regular to be the wind. "We do this my way," he said, though his voice shook more than he wanted it to.

Every choice had a price. The trick was knowing who would pay it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Every choice had a price. The trick was knowing who would pay it.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. The candle burned lower, and with it went the last of their patience. "We do this my way," he said, though his voice shook more than he wanted it to.

They walked in silence until the lights of the next town appeared through the trees. The candle burned lower, and with it went the last of their patience. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Footsteps echoed somewhere behind the wall, too regular to be the wind. "We do this my way," he said, though his voice shook more than he wanted it to. "You knew," she whispered. "You knew all along and you said nothing."

And then, very quietly, the door began to open.', NOW() - INTERVAL 258 HOUR),
(4, 4, 'Into the Dark', 'The bell rang three times before anyone dared to answer it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. A notice flickered into view, glowing faintly in the air in front of them. The old stories had always said the gate would open on its own. They had never said what would walk through it.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The candle burned lower, and with it went the last of their patience. Every choice had a price. The trick was knowing who would pay it.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. A notice flickered into view, glowing faintly in the air in front of them. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

They walked in silence until the lights of the next town appeared through the trees. They walked in silence until the lights of the next town appeared through the trees. Footsteps echoed somewhere behind the wall, too regular to be the wind.

Footsteps echoed somewhere behind the wall, too regular to be the wind. A notice flickered into view, glowing faintly in the air in front of them. The candle burned lower, and with it went the last of their patience.

And then, very quietly, the door began to open.', NOW() - INTERVAL 210 HOUR),
(4, 5, 'Old Promises', 'It had been raining for nine days when the stranger arrived. Every choice had a price. The trick was knowing who would pay it.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "We do this my way," he said, though his voice shook more than he wanted it to. They walked in silence until the lights of the next town appeared through the trees.

The candle burned lower, and with it went the last of their patience. The old stories had always said the gate would open on its own. They had never said what would walk through it. The old stories had always said the gate would open on its own. They had never said what would walk through it.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The old stories had always said the gate would open on its own. They had never said what would walk through it. They walked in silence until the lights of the next town appeared through the trees.

They walked in silence until the lights of the next town appeared through the trees. Every choice had a price. The trick was knowing who would pay it. A notice flickered into view, glowing faintly in the air in front of them.

"You knew," she whispered. "You knew all along and you said nothing." The old stories had always said the gate would open on its own. They had never said what would walk through it. A notice flickered into view, glowing faintly in the air in front of them.

He smiled for the first time that day.', NOW() - INTERVAL 162 HOUR),
(4, 6, 'The Long Night', 'The morning came slowly, grey light pooling at the edges of the window. Somewhere far off, a clock struck a time that did not exist.

A notice flickered into view, glowing faintly in the air in front of them. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The old stories had always said the gate would open on its own. They had never said what would walk through it.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "You knew," she whispered. "You knew all along and you said nothing." There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

"We do this my way," he said, though his voice shook more than he wanted it to. The candle burned lower, and with it went the last of their patience. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

They walked in silence until the lights of the next town appeared through the trees. Footsteps echoed somewhere behind the wall, too regular to be the wind. The candle burned lower, and with it went the last of their patience.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. A notice flickered into view, glowing faintly in the air in front of them. Every choice had a price. The trick was knowing who would pay it.

And then, very quietly, the door began to open.', NOW() - INTERVAL 114 HOUR),
(5, 1, 'A Strange Beginning', 'It had been raining for nine days when the stranger arrived. Somewhere far off, a clock struck a time that did not exist.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. The candle burned lower, and with it went the last of their patience. The old stories had always said the gate would open on its own. They had never said what would walk through it.

A notice flickered into view, glowing faintly in the air in front of them. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Somewhere far off, a clock struck a time that did not exist.

Footsteps echoed somewhere behind the wall, too regular to be the wind. A notice flickered into view, glowing faintly in the air in front of them. Somewhere far off, a clock struck a time that did not exist.

A notice flickered into view, glowing faintly in the air in front of them. The candle burned lower, and with it went the last of their patience. Somewhere far off, a clock struck a time that did not exist.

Every choice had a price. The trick was knowing who would pay it. Somewhere far off, a clock struck a time that did not exist. Somewhere far off, a clock struck a time that did not exist.

He smiled for the first time that day.', NOW() - INTERVAL 512 HOUR),
(5, 2, 'The First Step', 'It had been raining for nine days when the stranger arrived. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

The candle burned lower, and with it went the last of their patience. The candle burned lower, and with it went the last of their patience. Footsteps echoed somewhere behind the wall, too regular to be the wind.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. The candle burned lower, and with it went the last of their patience. They walked in silence until the lights of the next town appeared through the trees.

The old stories had always said the gate would open on its own. They had never said what would walk through it. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

They walked in silence until the lights of the next town appeared through the trees. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Footsteps echoed somewhere behind the wall, too regular to be the wind.

The old stories had always said the gate would open on its own. They had never said what would walk through it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "You knew," she whispered. "You knew all along and you said nothing."

He smiled for the first time that day.', NOW() - INTERVAL 464 HOUR),
(5, 3, 'Unexpected Guests', 'For the first time in years, the city was completely silent. "You knew," she whispered. "You knew all along and you said nothing."

Footsteps echoed somewhere behind the wall, too regular to be the wind. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Every choice had a price. The trick was knowing who would pay it. "You knew," she whispered. "You knew all along and you said nothing."

The old stories had always said the gate would open on its own. They had never said what would walk through it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "We do this my way," he said, though his voice shook more than he wanted it to.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. The old stories had always said the gate would open on its own. They had never said what would walk through it. "We do this my way," he said, though his voice shook more than he wanted it to.

"You knew," she whispered. "You knew all along and you said nothing." Every choice had a price. The trick was knowing who would pay it. Somewhere far off, a clock struck a time that did not exist.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 416 HOUR),
(5, 4, 'Into the Dark', 'The morning came slowly, grey light pooling at the edges of the window. Footsteps echoed somewhere behind the wall, too regular to be the wind.

Every choice had a price. The trick was knowing who would pay it. They walked in silence until the lights of the next town appeared through the trees. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Every choice had a price. The trick was knowing who would pay it. Every choice had a price. The trick was knowing who would pay it. Every choice had a price. The trick was knowing who would pay it.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Every choice had a price. The trick was knowing who would pay it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

The candle burned lower, and with it went the last of their patience. A notice flickered into view, glowing faintly in the air in front of them. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Somewhere far off, a clock struck a time that did not exist. They walked in silence until the lights of the next town appeared through the trees. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 368 HOUR),
(5, 5, 'Old Promises', 'Nobody had warned them that the road would end like this. They walked in silence until the lights of the next town appeared through the trees.

The old stories had always said the gate would open on its own. They had never said what would walk through it. A notice flickered into view, glowing faintly in the air in front of them. "We do this my way," he said, though his voice shook more than he wanted it to.

"You knew," she whispered. "You knew all along and you said nothing." Every choice had a price. The trick was knowing who would pay it. The old stories had always said the gate would open on its own. They had never said what would walk through it.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

"You knew," she whispered. "You knew all along and you said nothing." They walked in silence until the lights of the next town appeared through the trees. Footsteps echoed somewhere behind the wall, too regular to be the wind.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Footsteps echoed somewhere behind the wall, too regular to be the wind. "You knew," she whispered. "You knew all along and you said nothing."

And then, very quietly, the door began to open.', NOW() - INTERVAL 320 HOUR),
(5, 6, 'The Long Night', 'Nobody had warned them that the road would end like this. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

"We do this my way," he said, though his voice shook more than he wanted it to. "We do this my way," he said, though his voice shook more than he wanted it to. A notice flickered into view, glowing faintly in the air in front of them.

"We do this my way," he said, though his voice shook more than he wanted it to. The candle burned lower, and with it went the last of their patience. "You knew," she whispered. "You knew all along and you said nothing."

Every choice had a price. The trick was knowing who would pay it. The old stories had always said the gate would open on its own. They had never said what would walk through it. Every choice had a price. The trick was knowing who would pay it.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "We do this my way," he said, though his voice shook more than he wanted it to. Every choice had a price. The trick was knowing who would pay it.

"You knew," she whispered. "You knew all along and you said nothing." "We do this my way," he said, though his voice shook more than he wanted it to. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

And then, very quietly, the door began to open.', NOW() - INTERVAL 272 HOUR),
(5, 7, 'Broken Rules', 'It had been raining for nine days when the stranger arrived. The candle burned lower, and with it went the last of their patience.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The candle burned lower, and with it went the last of their patience. Every choice had a price. The trick was knowing who would pay it.

They walked in silence until the lights of the next town appeared through the trees. Somewhere far off, a clock struck a time that did not exist. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

"You knew," she whispered. "You knew all along and you said nothing." Somewhere far off, a clock struck a time that did not exist. They walked in silence until the lights of the next town appeared through the trees.

The candle burned lower, and with it went the last of their patience. "We do this my way," he said, though his voice shook more than he wanted it to. "You knew," she whispered. "You knew all along and you said nothing."

Every choice had a price. The trick was knowing who would pay it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Somewhere far off, a clock struck a time that did not exist.

It was only the beginning.', NOW() - INTERVAL 224 HOUR),
(5, 8, 'A Familiar Face', 'The morning came slowly, grey light pooling at the edges of the window. Somewhere far off, a clock struck a time that did not exist.

Somewhere far off, a clock struck a time that did not exist. The candle burned lower, and with it went the last of their patience. "We do this my way," he said, though his voice shook more than he wanted it to.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

A notice flickered into view, glowing faintly in the air in front of them. A notice flickered into view, glowing faintly in the air in front of them. The old stories had always said the gate would open on its own. They had never said what would walk through it.

"You knew," she whispered. "You knew all along and you said nothing." "You knew," she whispered. "You knew all along and you said nothing." She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. A notice flickered into view, glowing faintly in the air in front of them. They walked in silence until the lights of the next town appeared through the trees.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 176 HOUR),
(5, 9, 'Crossroads', 'The bell rang three times before anyone dared to answer it. "We do this my way," he said, though his voice shook more than he wanted it to.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Every choice had a price. The trick was knowing who would pay it. The old stories had always said the gate would open on its own. They had never said what would walk through it.

The old stories had always said the gate would open on its own. They had never said what would walk through it. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. A notice flickered into view, glowing faintly in the air in front of them.

Every choice had a price. The trick was knowing who would pay it. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Every choice had a price. The trick was knowing who would pay it.

"You knew," she whispered. "You knew all along and you said nothing." A notice flickered into view, glowing faintly in the air in front of them. "You knew," she whispered. "You knew all along and you said nothing."

"We do this my way," he said, though his voice shook more than he wanted it to. The old stories had always said the gate would open on its own. They had never said what would walk through it. They walked in silence until the lights of the next town appeared through the trees.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 128 HOUR),
(5, 10, 'Fire and Rain', 'Nobody had warned them that the road would end like this. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

"We do this my way," he said, though his voice shook more than he wanted it to. They walked in silence until the lights of the next town appeared through the trees. Footsteps echoed somewhere behind the wall, too regular to be the wind.

Every choice had a price. The trick was knowing who would pay it. A notice flickered into view, glowing faintly in the air in front of them. Every choice had a price. The trick was knowing who would pay it.

The old stories had always said the gate would open on its own. They had never said what would walk through it. A notice flickered into view, glowing faintly in the air in front of them. "We do this my way," he said, though his voice shook more than he wanted it to.

Somewhere far off, a clock struck a time that did not exist. They walked in silence until the lights of the next town appeared through the trees. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Every choice had a price. The trick was knowing who would pay it. The old stories had always said the gate would open on its own. They had never said what would walk through it. The old stories had always said the gate would open on its own. They had never said what would walk through it.

He smiled for the first time that day.', NOW() - INTERVAL 80 HOUR),
(5, 11, 'What Was Lost', 'It had been raining for nine days when the stranger arrived. Footsteps echoed somewhere behind the wall, too regular to be the wind.

Every choice had a price. The trick was knowing who would pay it. The old stories had always said the gate would open on its own. They had never said what would walk through it. A notice flickered into view, glowing faintly in the air in front of them.

The candle burned lower, and with it went the last of their patience. The old stories had always said the gate would open on its own. They had never said what would walk through it. A notice flickered into view, glowing faintly in the air in front of them.

"We do this my way," he said, though his voice shook more than he wanted it to. "You knew," she whispered. "You knew all along and you said nothing." "We do this my way," he said, though his voice shook more than he wanted it to.

The old stories had always said the gate would open on its own. They had never said what would walk through it. The old stories had always said the gate would open on its own. They had never said what would walk through it. Footsteps echoed somewhere behind the wall, too regular to be the wind.

They walked in silence until the lights of the next town appeared through the trees. "You knew," she whispered. "You knew all along and you said nothing." The candle burned lower, and with it went the last of their patience.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 32 HOUR),
(6, 1, 'A Strange Beginning', 'The morning came slowly, grey light pooling at the edges of the window. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

The candle burned lower, and with it went the last of their patience. Footsteps echoed somewhere behind the wall, too regular to be the wind. Footsteps echoed somewhere behind the wall, too regular to be the wind.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. A notice flickered into view, glowing faintly in the air in front of them. The candle burned lower, and with it went the last of their patience.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. A notice flickered into view, glowing faintly in the air in front of them.

"You knew," she whispered. "You knew all along and you said nothing." She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The candle burned lower, and with it went the last of their patience.

Footsteps echoed somewhere behind the wall, too regular to be the wind. The old stories had always said the gate would open on its own. They had never said what would walk through it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

And then, very quietly, the door began to open.', NOW() - INTERVAL 365 HOUR),
(6, 2, 'The First Step', 'Nobody had warned them that the road would end like this. Somewhere far off, a clock struck a time that did not exist.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Somewhere far off, a clock struck a time that did not exist. "We do this my way," he said, though his voice shook more than he wanted it to.

Footsteps echoed somewhere behind the wall, too regular to be the wind. A notice flickered into view, glowing faintly in the air in front of them. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

"We do this my way," he said, though his voice shook more than he wanted it to. "You knew," she whispered. "You knew all along and you said nothing." There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

"You knew," she whispered. "You knew all along and you said nothing." A notice flickered into view, glowing faintly in the air in front of them. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. A notice flickered into view, glowing faintly in the air in front of them. They walked in silence until the lights of the next town appeared through the trees.

And then, very quietly, the door began to open.', NOW() - INTERVAL 317 HOUR),
(6, 3, 'Unexpected Guests', 'For the first time in years, the city was completely silent. A notice flickered into view, glowing faintly in the air in front of them.

The old stories had always said the gate would open on its own. They had never said what would walk through it. The old stories had always said the gate would open on its own. They had never said what would walk through it. The candle burned lower, and with it went the last of their patience.

They walked in silence until the lights of the next town appeared through the trees. Every choice had a price. The trick was knowing who would pay it. Somewhere far off, a clock struck a time that did not exist.

"We do this my way," he said, though his voice shook more than he wanted it to. The candle burned lower, and with it went the last of their patience. They walked in silence until the lights of the next town appeared through the trees.

They walked in silence until the lights of the next town appeared through the trees. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Somewhere far off, a clock struck a time that did not exist.

"We do this my way," he said, though his voice shook more than he wanted it to. They walked in silence until the lights of the next town appeared through the trees. Footsteps echoed somewhere behind the wall, too regular to be the wind.

And then, very quietly, the door began to open.', NOW() - INTERVAL 269 HOUR),
(6, 4, 'Into the Dark', 'The morning came slowly, grey light pooling at the edges of the window. Every choice had a price. The trick was knowing who would pay it.

Footsteps echoed somewhere behind the wall, too regular to be the wind. Footsteps echoed somewhere behind the wall, too regular to be the wind. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

"We do this my way," he said, though his voice shook more than he wanted it to. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "You knew," she whispered. "You knew all along and you said nothing."

A notice flickered into view, glowing faintly in the air in front of them. Footsteps echoed somewhere behind the wall, too regular to be the wind. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Somewhere far off, a clock struck a time that did not exist. Footsteps echoed somewhere behind the wall, too regular to be the wind. Somewhere far off, a clock struck a time that did not exist.

They walked in silence until the lights of the next town appeared through the trees. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 221 HOUR),
(6, 5, 'Old Promises', 'Nobody had warned them that the road would end like this. "You knew," she whispered. "You knew all along and you said nothing."

They walked in silence until the lights of the next town appeared through the trees. A notice flickered into view, glowing faintly in the air in front of them. The candle burned lower, and with it went the last of their patience.

Somewhere far off, a clock struck a time that did not exist. Footsteps echoed somewhere behind the wall, too regular to be the wind. The old stories had always said the gate would open on its own. They had never said what would walk through it.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. The old stories had always said the gate would open on its own. They had never said what would walk through it.

"We do this my way," he said, though his voice shook more than he wanted it to. A notice flickered into view, glowing faintly in the air in front of them. A notice flickered into view, glowing faintly in the air in front of them.

Footsteps echoed somewhere behind the wall, too regular to be the wind. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Footsteps echoed somewhere behind the wall, too regular to be the wind.

It was only the beginning.', NOW() - INTERVAL 173 HOUR),
(6, 6, 'The Long Night', 'The morning came slowly, grey light pooling at the edges of the window. A notice flickered into view, glowing faintly in the air in front of them.

Somewhere far off, a clock struck a time that did not exist. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. They walked in silence until the lights of the next town appeared through the trees.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Every choice had a price. The trick was knowing who would pay it. The candle burned lower, and with it went the last of their patience.

A notice flickered into view, glowing faintly in the air in front of them. A notice flickered into view, glowing faintly in the air in front of them. The candle burned lower, and with it went the last of their patience.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Footsteps echoed somewhere behind the wall, too regular to be the wind. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

The candle burned lower, and with it went the last of their patience. The candle burned lower, and with it went the last of their patience. "You knew," she whispered. "You knew all along and you said nothing."

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 125 HOUR),
(6, 7, 'Broken Rules', 'The bell rang three times before anyone dared to answer it. Somewhere far off, a clock struck a time that did not exist.

Footsteps echoed somewhere behind the wall, too regular to be the wind. "We do this my way," he said, though his voice shook more than he wanted it to. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Every choice had a price. The trick was knowing who would pay it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Every choice had a price. The trick was knowing who would pay it.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Every choice had a price. The trick was knowing who would pay it. Every choice had a price. The trick was knowing who would pay it.

Footsteps echoed somewhere behind the wall, too regular to be the wind. Somewhere far off, a clock struck a time that did not exist. "We do this my way," he said, though his voice shook more than he wanted it to.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. A notice flickered into view, glowing faintly in the air in front of them. "You knew," she whispered. "You knew all along and you said nothing."

And then, very quietly, the door began to open.', NOW() - INTERVAL 77 HOUR),
(7, 1, 'A Strange Beginning', 'Nobody had warned them that the road would end like this. A notice flickered into view, glowing faintly in the air in front of them.

A notice flickered into view, glowing faintly in the air in front of them. They walked in silence until the lights of the next town appeared through the trees. The candle burned lower, and with it went the last of their patience.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. They walked in silence until the lights of the next town appeared through the trees.

The candle burned lower, and with it went the last of their patience. The old stories had always said the gate would open on its own. They had never said what would walk through it. Footsteps echoed somewhere behind the wall, too regular to be the wind.

A notice flickered into view, glowing faintly in the air in front of them. "We do this my way," he said, though his voice shook more than he wanted it to. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

They walked in silence until the lights of the next town appeared through the trees. Somewhere far off, a clock struck a time that did not exist. A notice flickered into view, glowing faintly in the air in front of them.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 234 HOUR),
(7, 2, 'The First Step', 'It had been raining for nine days when the stranger arrived. A notice flickered into view, glowing faintly in the air in front of them.

A notice flickered into view, glowing faintly in the air in front of them. Footsteps echoed somewhere behind the wall, too regular to be the wind. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Footsteps echoed somewhere behind the wall, too regular to be the wind. The candle burned lower, and with it went the last of their patience. The candle burned lower, and with it went the last of their patience.

Footsteps echoed somewhere behind the wall, too regular to be the wind. A notice flickered into view, glowing faintly in the air in front of them. "You knew," she whispered. "You knew all along and you said nothing."

The old stories had always said the gate would open on its own. They had never said what would walk through it. Footsteps echoed somewhere behind the wall, too regular to be the wind. Somewhere far off, a clock struck a time that did not exist.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "We do this my way," he said, though his voice shook more than he wanted it to. Every choice had a price. The trick was knowing who would pay it.

And then, very quietly, the door began to open.', NOW() - INTERVAL 186 HOUR),
(7, 3, 'Unexpected Guests', 'The bell rang three times before anyone dared to answer it. The old stories had always said the gate would open on its own. They had never said what would walk through it.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "We do this my way," he said, though his voice shook more than he wanted it to. The candle burned lower, and with it went the last of their patience.

"You knew," she whispered. "You knew all along and you said nothing." A notice flickered into view, glowing faintly in the air in front of them. "We do this my way," he said, though his voice shook more than he wanted it to.

"You knew," she whispered. "You knew all along and you said nothing." The candle burned lower, and with it went the last of their patience. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Every choice had a price. The trick was knowing who would pay it. Footsteps echoed somewhere behind the wall, too regular to be the wind. A notice flickered into view, glowing faintly in the air in front of them.

"We do this my way," he said, though his voice shook more than he wanted it to. The old stories had always said the gate would open on its own. They had never said what would walk through it. Somewhere far off, a clock struck a time that did not exist.

And then, very quietly, the door began to open.', NOW() - INTERVAL 138 HOUR),
(7, 4, 'Into the Dark', 'Nobody had warned them that the road would end like this. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Somewhere far off, a clock struck a time that did not exist. Footsteps echoed somewhere behind the wall, too regular to be the wind.

Every choice had a price. The trick was knowing who would pay it. "We do this my way," he said, though his voice shook more than he wanted it to. The candle burned lower, and with it went the last of their patience.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "You knew," she whispered. "You knew all along and you said nothing." Every choice had a price. The trick was knowing who would pay it.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. The candle burned lower, and with it went the last of their patience. They walked in silence until the lights of the next town appeared through the trees.

It was only the beginning.', NOW() - INTERVAL 90 HOUR),
(7, 5, 'Old Promises', 'The bell rang three times before anyone dared to answer it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. The candle burned lower, and with it went the last of their patience. Every choice had a price. The trick was knowing who would pay it.

"You knew," she whispered. "You knew all along and you said nothing." "We do this my way," he said, though his voice shook more than he wanted it to. They walked in silence until the lights of the next town appeared through the trees.

Somewhere far off, a clock struck a time that did not exist. The candle burned lower, and with it went the last of their patience. A notice flickered into view, glowing faintly in the air in front of them.

Somewhere far off, a clock struck a time that did not exist. A notice flickered into view, glowing faintly in the air in front of them. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Every choice had a price. The trick was knowing who would pay it. A notice flickered into view, glowing faintly in the air in front of them. Somewhere far off, a clock struck a time that did not exist.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 42 HOUR),
(8, 1, 'A Strange Beginning', 'The bell rang three times before anyone dared to answer it. Somewhere far off, a clock struck a time that did not exist.

They walked in silence until the lights of the next town appeared through the trees. They walked in silence until the lights of the next town appeared through the trees. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Every choice had a price. The trick was knowing who would pay it. Somewhere far off, a clock struck a time that did not exist.

A notice flickered into view, glowing faintly in the air in front of them. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. They walked in silence until the lights of the next town appeared through the trees.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Footsteps echoed somewhere behind the wall, too regular to be the wind.

The old stories had always said the gate would open on its own. They had never said what would walk through it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "You knew," she whispered. "You knew all along and you said nothing."

He smiled for the first time that day.', NOW() - INTERVAL 452 HOUR),
(8, 2, 'The First Step', 'The bell rang three times before anyone dared to answer it. The candle burned lower, and with it went the last of their patience.

They walked in silence until the lights of the next town appeared through the trees. "We do this my way," he said, though his voice shook more than he wanted it to. Every choice had a price. The trick was knowing who would pay it.

A notice flickered into view, glowing faintly in the air in front of them. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Footsteps echoed somewhere behind the wall, too regular to be the wind.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "You knew," she whispered. "You knew all along and you said nothing." The old stories had always said the gate would open on its own. They had never said what would walk through it.

"We do this my way," he said, though his voice shook more than he wanted it to. Somewhere far off, a clock struck a time that did not exist. The candle burned lower, and with it went the last of their patience.

It was only the beginning.', NOW() - INTERVAL 404 HOUR),
(8, 3, 'Unexpected Guests', 'The morning came slowly, grey light pooling at the edges of the window. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

The candle burned lower, and with it went the last of their patience. The old stories had always said the gate would open on its own. They had never said what would walk through it. The candle burned lower, and with it went the last of their patience.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. A notice flickered into view, glowing faintly in the air in front of them. Somewhere far off, a clock struck a time that did not exist.

Every choice had a price. The trick was knowing who would pay it. Somewhere far off, a clock struck a time that did not exist. The candle burned lower, and with it went the last of their patience.

Somewhere far off, a clock struck a time that did not exist. Footsteps echoed somewhere behind the wall, too regular to be the wind. Somewhere far off, a clock struck a time that did not exist.

They walked in silence until the lights of the next town appeared through the trees. "You knew," she whispered. "You knew all along and you said nothing." A notice flickered into view, glowing faintly in the air in front of them.

And then, very quietly, the door began to open.', NOW() - INTERVAL 356 HOUR),
(8, 4, 'Into the Dark', 'For the first time in years, the city was completely silent. A notice flickered into view, glowing faintly in the air in front of them.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "You knew," she whispered. "You knew all along and you said nothing." Footsteps echoed somewhere behind the wall, too regular to be the wind.

"We do this my way," he said, though his voice shook more than he wanted it to. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. They walked in silence until the lights of the next town appeared through the trees.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Every choice had a price. The trick was knowing who would pay it. The candle burned lower, and with it went the last of their patience.

A notice flickered into view, glowing faintly in the air in front of them. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "You knew," she whispered. "You knew all along and you said nothing."

Somewhere far off, a clock struck a time that did not exist. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

And then, very quietly, the door began to open.', NOW() - INTERVAL 308 HOUR),
(8, 5, 'Old Promises', 'The bell rang three times before anyone dared to answer it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

A notice flickered into view, glowing faintly in the air in front of them. The candle burned lower, and with it went the last of their patience. "We do this my way," he said, though his voice shook more than he wanted it to.

The candle burned lower, and with it went the last of their patience. A notice flickered into view, glowing faintly in the air in front of them. A notice flickered into view, glowing faintly in the air in front of them.

Footsteps echoed somewhere behind the wall, too regular to be the wind. Every choice had a price. The trick was knowing who would pay it. Somewhere far off, a clock struck a time that did not exist.

Footsteps echoed somewhere behind the wall, too regular to be the wind. Footsteps echoed somewhere behind the wall, too regular to be the wind. The old stories had always said the gate would open on its own. They had never said what would walk through it.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 260 HOUR),
(8, 6, 'The Long Night', 'It had been raining for nine days when the stranger arrived. The candle burned lower, and with it went the last of their patience.

A notice flickered into view, glowing faintly in the air in front of them. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. The old stories had always said the gate would open on its own. They had never said what would walk through it.

They walked in silence until the lights of the next town appeared through the trees. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Somewhere far off, a clock struck a time that did not exist. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "You knew," she whispered. "You knew all along and you said nothing."

The candle burned lower, and with it went the last of their patience. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 212 HOUR),
(8, 7, 'Broken Rules', 'The bell rang three times before anyone dared to answer it. "We do this my way," he said, though his voice shook more than he wanted it to.

Somewhere far off, a clock struck a time that did not exist. They walked in silence until the lights of the next town appeared through the trees. A notice flickered into view, glowing faintly in the air in front of them.

Every choice had a price. The trick was knowing who would pay it. "We do this my way," he said, though his voice shook more than he wanted it to. "You knew," she whispered. "You knew all along and you said nothing."

"You knew," she whispered. "You knew all along and you said nothing." Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. They walked in silence until the lights of the next town appeared through the trees.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The old stories had always said the gate would open on its own. They had never said what would walk through it. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Somewhere far off, a clock struck a time that did not exist.

It was only the beginning.', NOW() - INTERVAL 164 HOUR),
(8, 8, 'A Familiar Face', 'The morning came slowly, grey light pooling at the edges of the window. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. The old stories had always said the gate would open on its own. They had never said what would walk through it. A notice flickered into view, glowing faintly in the air in front of them.

They walked in silence until the lights of the next town appeared through the trees. "We do this my way," he said, though his voice shook more than he wanted it to. Somewhere far off, a clock struck a time that did not exist.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

"You knew," she whispered. "You knew all along and you said nothing." A notice flickered into view, glowing faintly in the air in front of them. The candle burned lower, and with it went the last of their patience.

It was only the beginning.', NOW() - INTERVAL 116 HOUR),
(8, 9, 'Crossroads', 'The morning came slowly, grey light pooling at the edges of the window. "You knew," she whispered. "You knew all along and you said nothing."

Somewhere far off, a clock struck a time that did not exist. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

"You knew," she whispered. "You knew all along and you said nothing." A notice flickered into view, glowing faintly in the air in front of them. A notice flickered into view, glowing faintly in the air in front of them.

A notice flickered into view, glowing faintly in the air in front of them. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

"You knew," she whispered. "You knew all along and you said nothing." A notice flickered into view, glowing faintly in the air in front of them. Every choice had a price. The trick was knowing who would pay it.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. The old stories had always said the gate would open on its own. They had never said what would walk through it. "We do this my way," he said, though his voice shook more than he wanted it to.

He smiled for the first time that day.', NOW() - INTERVAL 68 HOUR),
(9, 1, 'A Strange Beginning', 'It had been raining for nine days when the stranger arrived. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

The candle burned lower, and with it went the last of their patience. Every choice had a price. The trick was knowing who would pay it. Footsteps echoed somewhere behind the wall, too regular to be the wind.

The candle burned lower, and with it went the last of their patience. The old stories had always said the gate would open on its own. They had never said what would walk through it. The candle burned lower, and with it went the last of their patience.

Every choice had a price. The trick was knowing who would pay it. A notice flickered into view, glowing faintly in the air in front of them. The old stories had always said the gate would open on its own. They had never said what would walk through it.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Footsteps echoed somewhere behind the wall, too regular to be the wind. Somewhere far off, a clock struck a time that did not exist.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Footsteps echoed somewhere behind the wall, too regular to be the wind. They walked in silence until the lights of the next town appeared through the trees.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 472 HOUR),
(9, 2, 'The First Step', 'Nobody had warned them that the road would end like this. The candle burned lower, and with it went the last of their patience.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The old stories had always said the gate would open on its own. They had never said what would walk through it.

A notice flickered into view, glowing faintly in the air in front of them. A notice flickered into view, glowing faintly in the air in front of them. Every choice had a price. The trick was knowing who would pay it.

"We do this my way," he said, though his voice shook more than he wanted it to. The old stories had always said the gate would open on its own. They had never said what would walk through it. The old stories had always said the gate would open on its own. They had never said what would walk through it.

"We do this my way," he said, though his voice shook more than he wanted it to. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Somewhere far off, a clock struck a time that did not exist.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The old stories had always said the gate would open on its own. They had never said what would walk through it. The old stories had always said the gate would open on its own. They had never said what would walk through it.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 424 HOUR),
(9, 3, 'Unexpected Guests', 'The morning came slowly, grey light pooling at the edges of the window. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

"We do this my way," he said, though his voice shook more than he wanted it to. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

A notice flickered into view, glowing faintly in the air in front of them. The old stories had always said the gate would open on its own. They had never said what would walk through it. Every choice had a price. The trick was knowing who would pay it.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. The old stories had always said the gate would open on its own. They had never said what would walk through it.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The candle burned lower, and with it went the last of their patience.

Somewhere far off, a clock struck a time that did not exist. "We do this my way," he said, though his voice shook more than he wanted it to. The candle burned lower, and with it went the last of their patience.

And then, very quietly, the door began to open.', NOW() - INTERVAL 376 HOUR),
(9, 4, 'Into the Dark', 'For the first time in years, the city was completely silent. Footsteps echoed somewhere behind the wall, too regular to be the wind.

Every choice had a price. The trick was knowing who would pay it. The candle burned lower, and with it went the last of their patience. "We do this my way," he said, though his voice shook more than he wanted it to.

Somewhere far off, a clock struck a time that did not exist. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Every choice had a price. The trick was knowing who would pay it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Footsteps echoed somewhere behind the wall, too regular to be the wind.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The old stories had always said the gate would open on its own. They had never said what would walk through it. They walked in silence until the lights of the next town appeared through the trees.

"You knew," she whispered. "You knew all along and you said nothing." There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. They walked in silence until the lights of the next town appeared through the trees.

It was only the beginning.', NOW() - INTERVAL 328 HOUR),
(9, 5, 'Old Promises', 'Nobody had warned them that the road would end like this. Somewhere far off, a clock struck a time that did not exist.

"You knew," she whispered. "You knew all along and you said nothing." Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

They walked in silence until the lights of the next town appeared through the trees. A notice flickered into view, glowing faintly in the air in front of them. "You knew," she whispered. "You knew all along and you said nothing."

They walked in silence until the lights of the next town appeared through the trees. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Every choice had a price. The trick was knowing who would pay it. The candle burned lower, and with it went the last of their patience. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

"You knew," she whispered. "You knew all along and you said nothing." There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

It was only the beginning.', NOW() - INTERVAL 280 HOUR),
(9, 6, 'The Long Night', 'The morning came slowly, grey light pooling at the edges of the window. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Every choice had a price. The trick was knowing who would pay it. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "You knew," she whispered. "You knew all along and you said nothing."

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. They walked in silence until the lights of the next town appeared through the trees.

They walked in silence until the lights of the next town appeared through the trees. They walked in silence until the lights of the next town appeared through the trees. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Footsteps echoed somewhere behind the wall, too regular to be the wind. A notice flickered into view, glowing faintly in the air in front of them.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Somewhere far off, a clock struck a time that did not exist. "You knew," she whispered. "You knew all along and you said nothing."

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 232 HOUR),
(9, 7, 'Broken Rules', 'The morning came slowly, grey light pooling at the edges of the window. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. They walked in silence until the lights of the next town appeared through the trees.

"We do this my way," he said, though his voice shook more than he wanted it to. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Somewhere far off, a clock struck a time that did not exist.

Somewhere far off, a clock struck a time that did not exist. Every choice had a price. The trick was knowing who would pay it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Footsteps echoed somewhere behind the wall, too regular to be the wind. A notice flickered into view, glowing faintly in the air in front of them. "You knew," she whispered. "You knew all along and you said nothing."

The old stories had always said the gate would open on its own. They had never said what would walk through it. Somewhere far off, a clock struck a time that did not exist. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

It was only the beginning.', NOW() - INTERVAL 184 HOUR),
(9, 8, 'A Familiar Face', 'It had been raining for nine days when the stranger arrived. "We do this my way," he said, though his voice shook more than he wanted it to.

A notice flickered into view, glowing faintly in the air in front of them. Every choice had a price. The trick was knowing who would pay it. The old stories had always said the gate would open on its own. They had never said what would walk through it.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. They walked in silence until the lights of the next town appeared through the trees. "We do this my way," he said, though his voice shook more than he wanted it to.

The old stories had always said the gate would open on its own. They had never said what would walk through it. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Every choice had a price. The trick was knowing who would pay it.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. A notice flickered into view, glowing faintly in the air in front of them. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Footsteps echoed somewhere behind the wall, too regular to be the wind. They walked in silence until the lights of the next town appeared through the trees. The old stories had always said the gate would open on its own. They had never said what would walk through it.

It was only the beginning.', NOW() - INTERVAL 136 HOUR),
(9, 9, 'Crossroads', 'It had been raining for nine days when the stranger arrived. They walked in silence until the lights of the next town appeared through the trees.

Every choice had a price. The trick was knowing who would pay it. The candle burned lower, and with it went the last of their patience. A notice flickered into view, glowing faintly in the air in front of them.

They walked in silence until the lights of the next town appeared through the trees. Somewhere far off, a clock struck a time that did not exist. "We do this my way," he said, though his voice shook more than he wanted it to.

The candle burned lower, and with it went the last of their patience. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "You knew," she whispered. "You knew all along and you said nothing."

Every choice had a price. The trick was knowing who would pay it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Footsteps echoed somewhere behind the wall, too regular to be the wind.

They walked in silence until the lights of the next town appeared through the trees. Footsteps echoed somewhere behind the wall, too regular to be the wind. "You knew," she whispered. "You knew all along and you said nothing."

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 88 HOUR),
(9, 10, 'Fire and Rain', 'The morning came slowly, grey light pooling at the edges of the window. Footsteps echoed somewhere behind the wall, too regular to be the wind.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Somewhere far off, a clock struck a time that did not exist. "We do this my way," he said, though his voice shook more than he wanted it to.

"We do this my way," he said, though his voice shook more than he wanted it to. Footsteps echoed somewhere behind the wall, too regular to be the wind. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Somewhere far off, a clock struck a time that did not exist. The candle burned lower, and with it went the last of their patience.

Every choice had a price. The trick was knowing who would pay it. The candle burned lower, and with it went the last of their patience. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

The candle burned lower, and with it went the last of their patience. Footsteps echoed somewhere behind the wall, too regular to be the wind. They walked in silence until the lights of the next town appeared through the trees.

He smiled for the first time that day.', NOW() - INTERVAL 40 HOUR),
(10, 1, 'A Strange Beginning', 'The morning came slowly, grey light pooling at the edges of the window. The candle burned lower, and with it went the last of their patience.

Footsteps echoed somewhere behind the wall, too regular to be the wind. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "We do this my way," he said, though his voice shook more than he wanted it to.

"We do this my way," he said, though his voice shook more than he wanted it to. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Every choice had a price. The trick was knowing who would pay it. They walked in silence until the lights of the next town appeared through the trees. "You knew," she whispered. "You knew all along and you said nothing."

Every choice had a price. The trick was knowing who would pay it. The candle burned lower, and with it went the last of their patience. Somewhere far off, a clock struck a time that did not exist.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. A notice flickered into view, glowing faintly in the air in front of them. The old stories had always said the gate would open on its own. They had never said what would walk through it.

It was only the beginning.', NOW() - INTERVAL 554 HOUR),
(10, 2, 'The First Step', 'The morning came slowly, grey light pooling at the edges of the window. A notice flickered into view, glowing faintly in the air in front of them.

A notice flickered into view, glowing faintly in the air in front of them. Somewhere far off, a clock struck a time that did not exist. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

"We do this my way," he said, though his voice shook more than he wanted it to. Somewhere far off, a clock struck a time that did not exist. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Footsteps echoed somewhere behind the wall, too regular to be the wind. A notice flickered into view, glowing faintly in the air in front of them. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Every choice had a price. The trick was knowing who would pay it. Somewhere far off, a clock struck a time that did not exist. The old stories had always said the gate would open on its own. They had never said what would walk through it.

The old stories had always said the gate would open on its own. They had never said what would walk through it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 506 HOUR),
(10, 3, 'Unexpected Guests', 'It had been raining for nine days when the stranger arrived. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Somewhere far off, a clock struck a time that did not exist. The candle burned lower, and with it went the last of their patience. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "We do this my way," he said, though his voice shook more than he wanted it to. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

The candle burned lower, and with it went the last of their patience. Footsteps echoed somewhere behind the wall, too regular to be the wind. The candle burned lower, and with it went the last of their patience.

Footsteps echoed somewhere behind the wall, too regular to be the wind. Somewhere far off, a clock struck a time that did not exist. They walked in silence until the lights of the next town appeared through the trees.

It was only the beginning.', NOW() - INTERVAL 458 HOUR),
(10, 4, 'Into the Dark', 'For the first time in years, the city was completely silent. Somewhere far off, a clock struck a time that did not exist.

The candle burned lower, and with it went the last of their patience. Every choice had a price. The trick was knowing who would pay it. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

"You knew," she whispered. "You knew all along and you said nothing." She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The candle burned lower, and with it went the last of their patience.

The old stories had always said the gate would open on its own. They had never said what would walk through it. The old stories had always said the gate would open on its own. They had never said what would walk through it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

"We do this my way," he said, though his voice shook more than he wanted it to. "We do this my way," he said, though his voice shook more than he wanted it to. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Footsteps echoed somewhere behind the wall, too regular to be the wind. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "You knew," she whispered. "You knew all along and you said nothing."

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 410 HOUR),
(10, 5, 'Old Promises', 'It had been raining for nine days when the stranger arrived. The candle burned lower, and with it went the last of their patience.

They walked in silence until the lights of the next town appeared through the trees. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "We do this my way," he said, though his voice shook more than he wanted it to.

They walked in silence until the lights of the next town appeared through the trees. "We do this my way," he said, though his voice shook more than he wanted it to. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

They walked in silence until the lights of the next town appeared through the trees. Somewhere far off, a clock struck a time that did not exist. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

The old stories had always said the gate would open on its own. They had never said what would walk through it. The old stories had always said the gate would open on its own. They had never said what would walk through it. A notice flickered into view, glowing faintly in the air in front of them.

The old stories had always said the gate would open on its own. They had never said what would walk through it. "We do this my way," he said, though his voice shook more than he wanted it to. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 362 HOUR),
(10, 6, 'The Long Night', 'Nobody had warned them that the road would end like this. Somewhere far off, a clock struck a time that did not exist.

They walked in silence until the lights of the next town appeared through the trees. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The candle burned lower, and with it went the last of their patience.

Every choice had a price. The trick was knowing who would pay it. The candle burned lower, and with it went the last of their patience. "We do this my way," he said, though his voice shook more than he wanted it to.

Somewhere far off, a clock struck a time that did not exist. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The candle burned lower, and with it went the last of their patience.

Every choice had a price. The trick was knowing who would pay it. A notice flickered into view, glowing faintly in the air in front of them. The old stories had always said the gate would open on its own. They had never said what would walk through it.

A notice flickered into view, glowing faintly in the air in front of them. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "We do this my way," he said, though his voice shook more than he wanted it to.

It was only the beginning.', NOW() - INTERVAL 314 HOUR),
(10, 7, 'Broken Rules', 'The morning came slowly, grey light pooling at the edges of the window. "We do this my way," he said, though his voice shook more than he wanted it to.

They walked in silence until the lights of the next town appeared through the trees. They walked in silence until the lights of the next town appeared through the trees. A notice flickered into view, glowing faintly in the air in front of them.

A notice flickered into view, glowing faintly in the air in front of them. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Footsteps echoed somewhere behind the wall, too regular to be the wind.

A notice flickered into view, glowing faintly in the air in front of them. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

A notice flickered into view, glowing faintly in the air in front of them. A notice flickered into view, glowing faintly in the air in front of them. "We do this my way," he said, though his voice shook more than he wanted it to.

Footsteps echoed somewhere behind the wall, too regular to be the wind. A notice flickered into view, glowing faintly in the air in front of them. "We do this my way," he said, though his voice shook more than he wanted it to.

And then, very quietly, the door began to open.', NOW() - INTERVAL 266 HOUR),
(10, 8, 'A Familiar Face', 'It had been raining for nine days when the stranger arrived. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Footsteps echoed somewhere behind the wall, too regular to be the wind. Somewhere far off, a clock struck a time that did not exist. The old stories had always said the gate would open on its own. They had never said what would walk through it.

"You knew," she whispered. "You knew all along and you said nothing." The candle burned lower, and with it went the last of their patience. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Every choice had a price. The trick was knowing who would pay it. Every choice had a price. The trick was knowing who would pay it.

The candle burned lower, and with it went the last of their patience. A notice flickered into view, glowing faintly in the air in front of them. The old stories had always said the gate would open on its own. They had never said what would walk through it.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The candle burned lower, and with it went the last of their patience. Every choice had a price. The trick was knowing who would pay it.

And then, very quietly, the door began to open.', NOW() - INTERVAL 218 HOUR),
(10, 9, 'Crossroads', 'The morning came slowly, grey light pooling at the edges of the window. They walked in silence until the lights of the next town appeared through the trees.

A notice flickered into view, glowing faintly in the air in front of them. "We do this my way," he said, though his voice shook more than he wanted it to. Footsteps echoed somewhere behind the wall, too regular to be the wind.

The old stories had always said the gate would open on its own. They had never said what would walk through it. They walked in silence until the lights of the next town appeared through the trees. They walked in silence until the lights of the next town appeared through the trees.

"You knew," she whispered. "You knew all along and you said nothing." Somewhere far off, a clock struck a time that did not exist. The old stories had always said the gate would open on its own. They had never said what would walk through it.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Every choice had a price. The trick was knowing who would pay it. Somewhere far off, a clock struck a time that did not exist.

A notice flickered into view, glowing faintly in the air in front of them. Footsteps echoed somewhere behind the wall, too regular to be the wind. "We do this my way," he said, though his voice shook more than he wanted it to.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 170 HOUR),
(10, 10, 'Fire and Rain', 'The bell rang three times before anyone dared to answer it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Footsteps echoed somewhere behind the wall, too regular to be the wind. Every choice had a price. The trick was knowing who would pay it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Somewhere far off, a clock struck a time that did not exist. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Somewhere far off, a clock struck a time that did not exist.

A notice flickered into view, glowing faintly in the air in front of them. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. They walked in silence until the lights of the next town appeared through the trees. "We do this my way," he said, though his voice shook more than he wanted it to.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The old stories had always said the gate would open on its own. They had never said what would walk through it. "You knew," she whispered. "You knew all along and you said nothing."

And then, very quietly, the door began to open.', NOW() - INTERVAL 122 HOUR),
(10, 11, 'What Was Lost', 'For the first time in years, the city was completely silent. "You knew," she whispered. "You knew all along and you said nothing."

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Every choice had a price. The trick was knowing who would pay it. A notice flickered into view, glowing faintly in the air in front of them.

Somewhere far off, a clock struck a time that did not exist. Every choice had a price. The trick was knowing who would pay it. "We do this my way," he said, though his voice shook more than he wanted it to.

Somewhere far off, a clock struck a time that did not exist. Every choice had a price. The trick was knowing who would pay it. They walked in silence until the lights of the next town appeared through the trees.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Every choice had a price. The trick was knowing who would pay it. The old stories had always said the gate would open on its own. They had never said what would walk through it.

They walked in silence until the lights of the next town appeared through the trees. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. The old stories had always said the gate would open on its own. They had never said what would walk through it.

It was only the beginning.', NOW() - INTERVAL 74 HOUR),
(11, 1, 'A Strange Beginning', 'It had been raining for nine days when the stranger arrived. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "You knew," she whispered. "You knew all along and you said nothing." They walked in silence until the lights of the next town appeared through the trees.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "You knew," she whispered. "You knew all along and you said nothing." The old stories had always said the gate would open on its own. They had never said what would walk through it.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Footsteps echoed somewhere behind the wall, too regular to be the wind. Somewhere far off, a clock struck a time that did not exist.

They walked in silence until the lights of the next town appeared through the trees. They walked in silence until the lights of the next town appeared through the trees. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

The old stories had always said the gate would open on its own. They had never said what would walk through it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "You knew," she whispered. "You knew all along and you said nothing."

He smiled for the first time that day.', NOW() - INTERVAL 476 HOUR),
(11, 2, 'The First Step', 'For the first time in years, the city was completely silent. The old stories had always said the gate would open on its own. They had never said what would walk through it.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "We do this my way," he said, though his voice shook more than he wanted it to. "You knew," she whispered. "You knew all along and you said nothing."

They walked in silence until the lights of the next town appeared through the trees. "We do this my way," he said, though his voice shook more than he wanted it to. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Somewhere far off, a clock struck a time that did not exist. Every choice had a price. The trick was knowing who would pay it. "We do this my way," he said, though his voice shook more than he wanted it to.

The candle burned lower, and with it went the last of their patience. A notice flickered into view, glowing faintly in the air in front of them. "We do this my way," he said, though his voice shook more than he wanted it to.

Every choice had a price. The trick was knowing who would pay it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. The old stories had always said the gate would open on its own. They had never said what would walk through it.

And then, very quietly, the door began to open.', NOW() - INTERVAL 428 HOUR),
(11, 3, 'Unexpected Guests', 'Nobody had warned them that the road would end like this. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Footsteps echoed somewhere behind the wall, too regular to be the wind. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Footsteps echoed somewhere behind the wall, too regular to be the wind. Every choice had a price. The trick was knowing who would pay it. They walked in silence until the lights of the next town appeared through the trees.

They walked in silence until the lights of the next town appeared through the trees. "We do this my way," he said, though his voice shook more than he wanted it to. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

The candle burned lower, and with it went the last of their patience. Every choice had a price. The trick was knowing who would pay it. They walked in silence until the lights of the next town appeared through the trees.

A notice flickered into view, glowing faintly in the air in front of them. They walked in silence until the lights of the next town appeared through the trees. A notice flickered into view, glowing faintly in the air in front of them.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 380 HOUR),
(11, 4, 'Into the Dark', 'Nobody had warned them that the road would end like this. They walked in silence until the lights of the next town appeared through the trees.

The candle burned lower, and with it went the last of their patience. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. They walked in silence until the lights of the next town appeared through the trees.

"We do this my way," he said, though his voice shook more than he wanted it to. Footsteps echoed somewhere behind the wall, too regular to be the wind. Footsteps echoed somewhere behind the wall, too regular to be the wind.

The old stories had always said the gate would open on its own. They had never said what would walk through it. "You knew," she whispered. "You knew all along and you said nothing." She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. They walked in silence until the lights of the next town appeared through the trees. "You knew," she whispered. "You knew all along and you said nothing."

Footsteps echoed somewhere behind the wall, too regular to be the wind. The old stories had always said the gate would open on its own. They had never said what would walk through it. Somewhere far off, a clock struck a time that did not exist.

It was only the beginning.', NOW() - INTERVAL 332 HOUR),
(11, 5, 'Old Promises', 'It had been raining for nine days when the stranger arrived. Every choice had a price. The trick was knowing who would pay it.

Somewhere far off, a clock struck a time that did not exist. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

The candle burned lower, and with it went the last of their patience. They walked in silence until the lights of the next town appeared through the trees. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Somewhere far off, a clock struck a time that did not exist.

"We do this my way," he said, though his voice shook more than he wanted it to. A notice flickered into view, glowing faintly in the air in front of them. They walked in silence until the lights of the next town appeared through the trees.

They walked in silence until the lights of the next town appeared through the trees. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 284 HOUR),
(11, 6, 'The Long Night', 'For the first time in years, the city was completely silent. "We do this my way," he said, though his voice shook more than he wanted it to.

A notice flickered into view, glowing faintly in the air in front of them. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. The old stories had always said the gate would open on its own. They had never said what would walk through it.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Somewhere far off, a clock struck a time that did not exist. The candle burned lower, and with it went the last of their patience.

"We do this my way," he said, though his voice shook more than he wanted it to. A notice flickered into view, glowing faintly in the air in front of them. A notice flickered into view, glowing faintly in the air in front of them.

The old stories had always said the gate would open on its own. They had never said what would walk through it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Somewhere far off, a clock struck a time that did not exist.

Footsteps echoed somewhere behind the wall, too regular to be the wind. They walked in silence until the lights of the next town appeared through the trees. "You knew," she whispered. "You knew all along and you said nothing."

It was only the beginning.', NOW() - INTERVAL 236 HOUR),
(11, 7, 'Broken Rules', 'For the first time in years, the city was completely silent. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Somewhere far off, a clock struck a time that did not exist.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The old stories had always said the gate would open on its own. They had never said what would walk through it. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

The candle burned lower, and with it went the last of their patience. Every choice had a price. The trick was knowing who would pay it. They walked in silence until the lights of the next town appeared through the trees.

The old stories had always said the gate would open on its own. They had never said what would walk through it. "You knew," she whispered. "You knew all along and you said nothing." "You knew," she whispered. "You knew all along and you said nothing."

Every choice had a price. The trick was knowing who would pay it. The candle burned lower, and with it went the last of their patience. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

He smiled for the first time that day.', NOW() - INTERVAL 188 HOUR),
(11, 8, 'A Familiar Face', 'The bell rang three times before anyone dared to answer it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

"You knew," she whispered. "You knew all along and you said nothing." Somewhere far off, a clock struck a time that did not exist. A notice flickered into view, glowing faintly in the air in front of them.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Footsteps echoed somewhere behind the wall, too regular to be the wind.

"We do this my way," he said, though his voice shook more than he wanted it to. "We do this my way," he said, though his voice shook more than he wanted it to. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. They walked in silence until the lights of the next town appeared through the trees.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "We do this my way," he said, though his voice shook more than he wanted it to.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 140 HOUR),
(11, 9, 'Crossroads', 'Nobody had warned them that the road would end like this. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

A notice flickered into view, glowing faintly in the air in front of them. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Footsteps echoed somewhere behind the wall, too regular to be the wind.

A notice flickered into view, glowing faintly in the air in front of them. Somewhere far off, a clock struck a time that did not exist. "We do this my way," he said, though his voice shook more than he wanted it to.

The old stories had always said the gate would open on its own. They had never said what would walk through it. The candle burned lower, and with it went the last of their patience. A notice flickered into view, glowing faintly in the air in front of them.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Somewhere far off, a clock struck a time that did not exist. A notice flickered into view, glowing faintly in the air in front of them.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Somewhere far off, a clock struck a time that did not exist. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 92 HOUR),
(11, 10, 'Fire and Rain', 'The bell rang three times before anyone dared to answer it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Footsteps echoed somewhere behind the wall, too regular to be the wind. The candle burned lower, and with it went the last of their patience. The old stories had always said the gate would open on its own. They had never said what would walk through it.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Every choice had a price. The trick was knowing who would pay it. The candle burned lower, and with it went the last of their patience.

"You knew," she whispered. "You knew all along and you said nothing." There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "You knew," she whispered. "You knew all along and you said nothing."

A notice flickered into view, glowing faintly in the air in front of them. "You knew," she whispered. "You knew all along and you said nothing." "You knew," she whispered. "You knew all along and you said nothing."

"You knew," she whispered. "You knew all along and you said nothing." Footsteps echoed somewhere behind the wall, too regular to be the wind. The old stories had always said the gate would open on its own. They had never said what would walk through it.

It was only the beginning.', NOW() - INTERVAL 44 HOUR),
(12, 1, 'A Strange Beginning', 'Nobody had warned them that the road would end like this. Every choice had a price. The trick was knowing who would pay it.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

"We do this my way," he said, though his voice shook more than he wanted it to. "We do this my way," he said, though his voice shook more than he wanted it to. Somewhere far off, a clock struck a time that did not exist.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "You knew," she whispered. "You knew all along and you said nothing." Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

They walked in silence until the lights of the next town appeared through the trees. Somewhere far off, a clock struck a time that did not exist. They walked in silence until the lights of the next town appeared through the trees.

"We do this my way," he said, though his voice shook more than he wanted it to. They walked in silence until the lights of the next town appeared through the trees. The candle burned lower, and with it went the last of their patience.

And then, very quietly, the door began to open.', NOW() - INTERVAL 504 HOUR),
(12, 2, 'The First Step', 'The morning came slowly, grey light pooling at the edges of the window. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Somewhere far off, a clock struck a time that did not exist. Every choice had a price. The trick was knowing who would pay it. They walked in silence until the lights of the next town appeared through the trees.

The candle burned lower, and with it went the last of their patience. A notice flickered into view, glowing faintly in the air in front of them. Every choice had a price. The trick was knowing who would pay it.

A notice flickered into view, glowing faintly in the air in front of them. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. They walked in silence until the lights of the next town appeared through the trees.

The old stories had always said the gate would open on its own. They had never said what would walk through it. "We do this my way," he said, though his voice shook more than he wanted it to. Every choice had a price. The trick was knowing who would pay it.

They walked in silence until the lights of the next town appeared through the trees. A notice flickered into view, glowing faintly in the air in front of them. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 456 HOUR),
(12, 3, 'Unexpected Guests', 'For the first time in years, the city was completely silent. Somewhere far off, a clock struck a time that did not exist.

Somewhere far off, a clock struck a time that did not exist. They walked in silence until the lights of the next town appeared through the trees. Somewhere far off, a clock struck a time that did not exist.

"We do this my way," he said, though his voice shook more than he wanted it to. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "We do this my way," he said, though his voice shook more than he wanted it to.

The candle burned lower, and with it went the last of their patience. The old stories had always said the gate would open on its own. They had never said what would walk through it. A notice flickered into view, glowing faintly in the air in front of them.

Somewhere far off, a clock struck a time that did not exist. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Somewhere far off, a clock struck a time that did not exist.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Every choice had a price. The trick was knowing who would pay it. The candle burned lower, and with it went the last of their patience.

And then, very quietly, the door began to open.', NOW() - INTERVAL 408 HOUR),
(12, 4, 'Into the Dark', 'It had been raining for nine days when the stranger arrived. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

"You knew," she whispered. "You knew all along and you said nothing." They walked in silence until the lights of the next town appeared through the trees. "You knew," she whispered. "You knew all along and you said nothing."

The candle burned lower, and with it went the last of their patience. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Footsteps echoed somewhere behind the wall, too regular to be the wind.

"We do this my way," he said, though his voice shook more than he wanted it to. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "You knew," she whispered. "You knew all along and you said nothing."

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Footsteps echoed somewhere behind the wall, too regular to be the wind.

A notice flickered into view, glowing faintly in the air in front of them. "We do this my way," he said, though his voice shook more than he wanted it to. Somewhere far off, a clock struck a time that did not exist.

It was only the beginning.', NOW() - INTERVAL 360 HOUR),
(12, 5, 'Old Promises', 'Nobody had warned them that the road would end like this. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

The old stories had always said the gate would open on its own. They had never said what would walk through it. They walked in silence until the lights of the next town appeared through the trees. The old stories had always said the gate would open on its own. They had never said what would walk through it.

"We do this my way," he said, though his voice shook more than he wanted it to. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Footsteps echoed somewhere behind the wall, too regular to be the wind. The old stories had always said the gate would open on its own. They had never said what would walk through it.

The candle burned lower, and with it went the last of their patience. Footsteps echoed somewhere behind the wall, too regular to be the wind. The old stories had always said the gate would open on its own. They had never said what would walk through it.

The old stories had always said the gate would open on its own. They had never said what would walk through it. "You knew," she whispered. "You knew all along and you said nothing." The candle burned lower, and with it went the last of their patience.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 312 HOUR),
(12, 6, 'The Long Night', 'For the first time in years, the city was completely silent. Somewhere far off, a clock struck a time that did not exist.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "You knew," she whispered. "You knew all along and you said nothing." The candle burned lower, and with it went the last of their patience.

Every choice had a price. The trick was knowing who would pay it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Every choice had a price. The trick was knowing who would pay it.

Somewhere far off, a clock struck a time that did not exist. "You knew," she whispered. "You knew all along and you said nothing." The old stories had always said the gate would open on its own. They had never said what would walk through it.

"You knew," she whispered. "You knew all along and you said nothing." Footsteps echoed somewhere behind the wall, too regular to be the wind. "You knew," she whispered. "You knew all along and you said nothing."

They walked in silence until the lights of the next town appeared through the trees. Every choice had a price. The trick was knowing who would pay it. The candle burned lower, and with it went the last of their patience.

He smiled for the first time that day.', NOW() - INTERVAL 264 HOUR),
(12, 7, 'Broken Rules', 'It had been raining for nine days when the stranger arrived. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Footsteps echoed somewhere behind the wall, too regular to be the wind. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "You knew," she whispered. "You knew all along and you said nothing." "You knew," she whispered. "You knew all along and you said nothing."

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Every choice had a price. The trick was knowing who would pay it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Every choice had a price. The trick was knowing who would pay it. A notice flickered into view, glowing faintly in the air in front of them. A notice flickered into view, glowing faintly in the air in front of them.

The old stories had always said the gate would open on its own. They had never said what would walk through it. "You knew," she whispered. "You knew all along and you said nothing." Every choice had a price. The trick was knowing who would pay it.

And then, very quietly, the door began to open.', NOW() - INTERVAL 216 HOUR),
(12, 8, 'A Familiar Face', 'The bell rang three times before anyone dared to answer it. The candle burned lower, and with it went the last of their patience.

A notice flickered into view, glowing faintly in the air in front of them. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Somewhere far off, a clock struck a time that did not exist. The old stories had always said the gate would open on its own. They had never said what would walk through it.

They walked in silence until the lights of the next town appeared through the trees. Footsteps echoed somewhere behind the wall, too regular to be the wind. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Footsteps echoed somewhere behind the wall, too regular to be the wind. "We do this my way," he said, though his voice shook more than he wanted it to.

Every choice had a price. The trick was knowing who would pay it. A notice flickered into view, glowing faintly in the air in front of them. Somewhere far off, a clock struck a time that did not exist.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 168 HOUR),
(12, 9, 'Crossroads', 'The morning came slowly, grey light pooling at the edges of the window. Every choice had a price. The trick was knowing who would pay it.

They walked in silence until the lights of the next town appeared through the trees. Somewhere far off, a clock struck a time that did not exist. Every choice had a price. The trick was knowing who would pay it.

"You knew," she whispered. "You knew all along and you said nothing." Somewhere far off, a clock struck a time that did not exist. Every choice had a price. The trick was knowing who would pay it.

The candle burned lower, and with it went the last of their patience. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "We do this my way," he said, though his voice shook more than he wanted it to. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "We do this my way," he said, though his voice shook more than he wanted it to. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 120 HOUR),
(12, 10, 'Fire and Rain', 'Nobody had warned them that the road would end like this. Footsteps echoed somewhere behind the wall, too regular to be the wind.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The old stories had always said the gate would open on its own. They had never said what would walk through it. Somewhere far off, a clock struck a time that did not exist.

"You knew," she whispered. "You knew all along and you said nothing." A notice flickered into view, glowing faintly in the air in front of them. A notice flickered into view, glowing faintly in the air in front of them.

"We do this my way," he said, though his voice shook more than he wanted it to. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

A notice flickered into view, glowing faintly in the air in front of them. The old stories had always said the gate would open on its own. They had never said what would walk through it. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Footsteps echoed somewhere behind the wall, too regular to be the wind. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

He smiled for the first time that day.', NOW() - INTERVAL 72 HOUR),
(13, 1, 'A Strange Beginning', 'Nobody had warned them that the road would end like this. "We do this my way," he said, though his voice shook more than he wanted it to.

"You knew," she whispered. "You knew all along and you said nothing." They walked in silence until the lights of the next town appeared through the trees. Somewhere far off, a clock struck a time that did not exist.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. They walked in silence until the lights of the next town appeared through the trees. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Somewhere far off, a clock struck a time that did not exist. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Every choice had a price. The trick was knowing who would pay it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "You knew," she whispered. "You knew all along and you said nothing."

"We do this my way," he said, though his voice shook more than he wanted it to. Footsteps echoed somewhere behind the wall, too regular to be the wind. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 370 HOUR),
(13, 2, 'The First Step', 'For the first time in years, the city was completely silent. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

They walked in silence until the lights of the next town appeared through the trees. "You knew," she whispered. "You knew all along and you said nothing." Every choice had a price. The trick was knowing who would pay it.

They walked in silence until the lights of the next town appeared through the trees. Every choice had a price. The trick was knowing who would pay it. The old stories had always said the gate would open on its own. They had never said what would walk through it.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The old stories had always said the gate would open on its own. They had never said what would walk through it. Footsteps echoed somewhere behind the wall, too regular to be the wind.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Footsteps echoed somewhere behind the wall, too regular to be the wind. "We do this my way," he said, though his voice shook more than he wanted it to.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. They walked in silence until the lights of the next town appeared through the trees.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 322 HOUR),
(13, 3, 'Unexpected Guests', 'The bell rang three times before anyone dared to answer it. The candle burned lower, and with it went the last of their patience.

"You knew," she whispered. "You knew all along and you said nothing." The old stories had always said the gate would open on its own. They had never said what would walk through it. "You knew," she whispered. "You knew all along and you said nothing."

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Footsteps echoed somewhere behind the wall, too regular to be the wind. They walked in silence until the lights of the next town appeared through the trees.

A notice flickered into view, glowing faintly in the air in front of them. They walked in silence until the lights of the next town appeared through the trees. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Somewhere far off, a clock struck a time that did not exist. A notice flickered into view, glowing faintly in the air in front of them. The candle burned lower, and with it went the last of their patience.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. They walked in silence until the lights of the next town appeared through the trees. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

And then, very quietly, the door began to open.', NOW() - INTERVAL 274 HOUR),
(13, 4, 'Into the Dark', 'The bell rang three times before anyone dared to answer it. "You knew," she whispered. "You knew all along and you said nothing."

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. The old stories had always said the gate would open on its own. They had never said what would walk through it. The old stories had always said the gate would open on its own. They had never said what would walk through it.

A notice flickered into view, glowing faintly in the air in front of them. A notice flickered into view, glowing faintly in the air in front of them. Footsteps echoed somewhere behind the wall, too regular to be the wind.

They walked in silence until the lights of the next town appeared through the trees. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. They walked in silence until the lights of the next town appeared through the trees.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Somewhere far off, a clock struck a time that did not exist. "You knew," she whispered. "You knew all along and you said nothing."

A notice flickered into view, glowing faintly in the air in front of them. "You knew," she whispered. "You knew all along and you said nothing." "You knew," she whispered. "You knew all along and you said nothing."

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 226 HOUR),
(13, 5, 'Old Promises', 'For the first time in years, the city was completely silent. "We do this my way," he said, though his voice shook more than he wanted it to.

Footsteps echoed somewhere behind the wall, too regular to be the wind. The old stories had always said the gate would open on its own. They had never said what would walk through it. Footsteps echoed somewhere behind the wall, too regular to be the wind.

A notice flickered into view, glowing faintly in the air in front of them. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "You knew," she whispered. "You knew all along and you said nothing."

The old stories had always said the gate would open on its own. They had never said what would walk through it. Somewhere far off, a clock struck a time that did not exist. Somewhere far off, a clock struck a time that did not exist.

Every choice had a price. The trick was knowing who would pay it. A notice flickered into view, glowing faintly in the air in front of them. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. A notice flickered into view, glowing faintly in the air in front of them. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

He smiled for the first time that day.', NOW() - INTERVAL 178 HOUR),
(13, 6, 'The Long Night', 'For the first time in years, the city was completely silent. The old stories had always said the gate would open on its own. They had never said what would walk through it.

The candle burned lower, and with it went the last of their patience. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "You knew," she whispered. "You knew all along and you said nothing." Every choice had a price. The trick was knowing who would pay it.

"We do this my way," he said, though his voice shook more than he wanted it to. They walked in silence until the lights of the next town appeared through the trees. The candle burned lower, and with it went the last of their patience.

Somewhere far off, a clock struck a time that did not exist. "You knew," she whispered. "You knew all along and you said nothing." There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

The candle burned lower, and with it went the last of their patience. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Somewhere far off, a clock struck a time that did not exist.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 130 HOUR),
(13, 7, 'Broken Rules', 'Nobody had warned them that the road would end like this. They walked in silence until the lights of the next town appeared through the trees.

Every choice had a price. The trick was knowing who would pay it. Footsteps echoed somewhere behind the wall, too regular to be the wind. "We do this my way," he said, though his voice shook more than he wanted it to.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. A notice flickered into view, glowing faintly in the air in front of them.

They walked in silence until the lights of the next town appeared through the trees. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. The old stories had always said the gate would open on its own. They had never said what would walk through it.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. A notice flickered into view, glowing faintly in the air in front of them.

A notice flickered into view, glowing faintly in the air in front of them. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. A notice flickered into view, glowing faintly in the air in front of them.

It was only the beginning.', NOW() - INTERVAL 82 HOUR),
(13, 8, 'A Familiar Face', 'The bell rang three times before anyone dared to answer it. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

The old stories had always said the gate would open on its own. They had never said what would walk through it. "We do this my way," he said, though his voice shook more than he wanted it to. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

The candle burned lower, and with it went the last of their patience. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. The candle burned lower, and with it went the last of their patience.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

"You knew," she whispered. "You knew all along and you said nothing." The old stories had always said the gate would open on its own. They had never said what would walk through it. "You knew," she whispered. "You knew all along and you said nothing."

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "We do this my way," he said, though his voice shook more than he wanted it to.

And then, very quietly, the door began to open.', NOW() - INTERVAL 34 HOUR),
(14, 1, 'A Strange Beginning', 'Nobody had warned them that the road would end like this. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

They walked in silence until the lights of the next town appeared through the trees. "We do this my way," he said, though his voice shook more than he wanted it to. Every choice had a price. The trick was knowing who would pay it.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. A notice flickered into view, glowing faintly in the air in front of them.

"We do this my way," he said, though his voice shook more than he wanted it to. Every choice had a price. The trick was knowing who would pay it. A notice flickered into view, glowing faintly in the air in front of them.

The candle burned lower, and with it went the last of their patience. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

He smiled for the first time that day.', NOW() - INTERVAL 302 HOUR),
(14, 2, 'The First Step', 'For the first time in years, the city was completely silent. The candle burned lower, and with it went the last of their patience.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

"We do this my way," he said, though his voice shook more than he wanted it to. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Footsteps echoed somewhere behind the wall, too regular to be the wind.

Footsteps echoed somewhere behind the wall, too regular to be the wind. Somewhere far off, a clock struck a time that did not exist. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

A notice flickered into view, glowing faintly in the air in front of them. A notice flickered into view, glowing faintly in the air in front of them. Every choice had a price. The trick was knowing who would pay it.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Footsteps echoed somewhere behind the wall, too regular to be the wind.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 254 HOUR),
(14, 3, 'Unexpected Guests', 'It had been raining for nine days when the stranger arrived. Somewhere far off, a clock struck a time that did not exist.

Somewhere far off, a clock struck a time that did not exist. Every choice had a price. The trick was knowing who would pay it. "We do this my way," he said, though his voice shook more than he wanted it to.

The old stories had always said the gate would open on its own. They had never said what would walk through it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. They walked in silence until the lights of the next town appeared through the trees.

They walked in silence until the lights of the next town appeared through the trees. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Footsteps echoed somewhere behind the wall, too regular to be the wind. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

The old stories had always said the gate would open on its own. They had never said what would walk through it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Somewhere far off, a clock struck a time that did not exist.

He smiled for the first time that day.', NOW() - INTERVAL 206 HOUR),
(14, 4, 'Into the Dark', 'For the first time in years, the city was completely silent. The old stories had always said the gate would open on its own. They had never said what would walk through it.

The old stories had always said the gate would open on its own. They had never said what would walk through it. They walked in silence until the lights of the next town appeared through the trees. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

The old stories had always said the gate would open on its own. They had never said what would walk through it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

They walked in silence until the lights of the next town appeared through the trees. The candle burned lower, and with it went the last of their patience. Footsteps echoed somewhere behind the wall, too regular to be the wind.

They walked in silence until the lights of the next town appeared through the trees. Somewhere far off, a clock struck a time that did not exist. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Every choice had a price. The trick was knowing who would pay it. They walked in silence until the lights of the next town appeared through the trees. "We do this my way," he said, though his voice shook more than he wanted it to.

It was only the beginning.', NOW() - INTERVAL 158 HOUR),
(14, 5, 'Old Promises', 'It had been raining for nine days when the stranger arrived. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

The old stories had always said the gate would open on its own. They had never said what would walk through it. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Footsteps echoed somewhere behind the wall, too regular to be the wind.

Every choice had a price. The trick was knowing who would pay it. Somewhere far off, a clock struck a time that did not exist. They walked in silence until the lights of the next town appeared through the trees.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. A notice flickered into view, glowing faintly in the air in front of them.

"You knew," she whispered. "You knew all along and you said nothing." Somewhere far off, a clock struck a time that did not exist. Footsteps echoed somewhere behind the wall, too regular to be the wind.

Somewhere far off, a clock struck a time that did not exist. The candle burned lower, and with it went the last of their patience. "You knew," she whispered. "You knew all along and you said nothing."

It was only the beginning.', NOW() - INTERVAL 110 HOUR),
(14, 6, 'The Long Night', 'For the first time in years, the city was completely silent. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

"We do this my way," he said, though his voice shook more than he wanted it to. Footsteps echoed somewhere behind the wall, too regular to be the wind. The candle burned lower, and with it went the last of their patience.

Every choice had a price. The trick was knowing who would pay it. The old stories had always said the gate would open on its own. They had never said what would walk through it. The candle burned lower, and with it went the last of their patience.

Every choice had a price. The trick was knowing who would pay it. "We do this my way," he said, though his voice shook more than he wanted it to. They walked in silence until the lights of the next town appeared through the trees.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. A notice flickered into view, glowing faintly in the air in front of them. Every choice had a price. The trick was knowing who would pay it.

The old stories had always said the gate would open on its own. They had never said what would walk through it. "You knew," she whispered. "You knew all along and you said nothing." "We do this my way," he said, though his voice shook more than he wanted it to.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 62 HOUR),
(15, 1, 'A Strange Beginning', 'The bell rang three times before anyone dared to answer it. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Footsteps echoed somewhere behind the wall, too regular to be the wind. "We do this my way," he said, though his voice shook more than he wanted it to.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. The old stories had always said the gate would open on its own. They had never said what would walk through it. A notice flickered into view, glowing faintly in the air in front of them.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Every choice had a price. The trick was knowing who would pay it. They walked in silence until the lights of the next town appeared through the trees.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Every choice had a price. The trick was knowing who would pay it. Every choice had a price. The trick was knowing who would pay it.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. The old stories had always said the gate would open on its own. They had never said what would walk through it.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 583 HOUR),
(15, 2, 'The First Step', 'Nobody had warned them that the road would end like this. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

"You knew," she whispered. "You knew all along and you said nothing." The candle burned lower, and with it went the last of their patience. Footsteps echoed somewhere behind the wall, too regular to be the wind.

They walked in silence until the lights of the next town appeared through the trees. Every choice had a price. The trick was knowing who would pay it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Somewhere far off, a clock struck a time that did not exist. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Somewhere far off, a clock struck a time that did not exist.

"We do this my way," he said, though his voice shook more than he wanted it to. The old stories had always said the gate would open on its own. They had never said what would walk through it. Footsteps echoed somewhere behind the wall, too regular to be the wind.

Somewhere far off, a clock struck a time that did not exist. A notice flickered into view, glowing faintly in the air in front of them. "We do this my way," he said, though his voice shook more than he wanted it to.

And then, very quietly, the door began to open.', NOW() - INTERVAL 535 HOUR),
(15, 3, 'Unexpected Guests', 'The bell rang three times before anyone dared to answer it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

"You knew," she whispered. "You knew all along and you said nothing." She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. A notice flickered into view, glowing faintly in the air in front of them.

They walked in silence until the lights of the next town appeared through the trees. A notice flickered into view, glowing faintly in the air in front of them. Somewhere far off, a clock struck a time that did not exist.

Every choice had a price. The trick was knowing who would pay it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. The old stories had always said the gate would open on its own. They had never said what would walk through it.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. The old stories had always said the gate would open on its own. They had never said what would walk through it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Footsteps echoed somewhere behind the wall, too regular to be the wind. The candle burned lower, and with it went the last of their patience.

It was only the beginning.', NOW() - INTERVAL 487 HOUR),
(15, 4, 'Into the Dark', 'Nobody had warned them that the road would end like this. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

A notice flickered into view, glowing faintly in the air in front of them. A notice flickered into view, glowing faintly in the air in front of them. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Somewhere far off, a clock struck a time that did not exist. "We do this my way," he said, though his voice shook more than he wanted it to. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

The candle burned lower, and with it went the last of their patience. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "We do this my way," he said, though his voice shook more than he wanted it to.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "You knew," she whispered. "You knew all along and you said nothing." There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Footsteps echoed somewhere behind the wall, too regular to be the wind. They walked in silence until the lights of the next town appeared through the trees.

And then, very quietly, the door began to open.', NOW() - INTERVAL 439 HOUR),
(15, 5, 'Old Promises', 'The morning came slowly, grey light pooling at the edges of the window. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "You knew," she whispered. "You knew all along and you said nothing." "You knew," she whispered. "You knew all along and you said nothing."

They walked in silence until the lights of the next town appeared through the trees. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "You knew," she whispered. "You knew all along and you said nothing."

Somewhere far off, a clock struck a time that did not exist. Footsteps echoed somewhere behind the wall, too regular to be the wind. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Every choice had a price. The trick was knowing who would pay it. Somewhere far off, a clock struck a time that did not exist. Every choice had a price. The trick was knowing who would pay it.

The candle burned lower, and with it went the last of their patience. They walked in silence until the lights of the next town appeared through the trees. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 391 HOUR),
(15, 6, 'The Long Night', 'The bell rang three times before anyone dared to answer it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. The old stories had always said the gate would open on its own. They had never said what would walk through it. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Somewhere far off, a clock struck a time that did not exist. Somewhere far off, a clock struck a time that did not exist. Somewhere far off, a clock struck a time that did not exist.

Footsteps echoed somewhere behind the wall, too regular to be the wind. The old stories had always said the gate would open on its own. They had never said what would walk through it. The candle burned lower, and with it went the last of their patience.

"You knew," she whispered. "You knew all along and you said nothing." The candle burned lower, and with it went the last of their patience. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

The candle burned lower, and with it went the last of their patience. The old stories had always said the gate would open on its own. They had never said what would walk through it. Every choice had a price. The trick was knowing who would pay it.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 343 HOUR),
(15, 7, 'Broken Rules', 'For the first time in years, the city was completely silent. A notice flickered into view, glowing faintly in the air in front of them.

"You knew," she whispered. "You knew all along and you said nothing." Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "We do this my way," he said, though his voice shook more than he wanted it to.

"We do this my way," he said, though his voice shook more than he wanted it to. The old stories had always said the gate would open on its own. They had never said what would walk through it. The candle burned lower, and with it went the last of their patience.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. A notice flickered into view, glowing faintly in the air in front of them. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

The candle burned lower, and with it went the last of their patience. They walked in silence until the lights of the next town appeared through the trees. "We do this my way," he said, though his voice shook more than he wanted it to.

"We do this my way," he said, though his voice shook more than he wanted it to. Every choice had a price. The trick was knowing who would pay it. Every choice had a price. The trick was knowing who would pay it.

It was only the beginning.', NOW() - INTERVAL 295 HOUR),
(15, 8, 'A Familiar Face', 'Nobody had warned them that the road would end like this. Every choice had a price. The trick was knowing who would pay it.

"You knew," she whispered. "You knew all along and you said nothing." They walked in silence until the lights of the next town appeared through the trees. "We do this my way," he said, though his voice shook more than he wanted it to.

Somewhere far off, a clock struck a time that did not exist. Somewhere far off, a clock struck a time that did not exist. A notice flickered into view, glowing faintly in the air in front of them.

They walked in silence until the lights of the next town appeared through the trees. Every choice had a price. The trick was knowing who would pay it. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

"We do this my way," he said, though his voice shook more than he wanted it to. They walked in silence until the lights of the next town appeared through the trees. Footsteps echoed somewhere behind the wall, too regular to be the wind.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "We do this my way," he said, though his voice shook more than he wanted it to.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 247 HOUR),
(15, 9, 'Crossroads', 'It had been raining for nine days when the stranger arrived. The old stories had always said the gate would open on its own. They had never said what would walk through it.

"We do this my way," he said, though his voice shook more than he wanted it to. The candle burned lower, and with it went the last of their patience. Somewhere far off, a clock struck a time that did not exist.

"We do this my way," he said, though his voice shook more than he wanted it to. "We do this my way," he said, though his voice shook more than he wanted it to. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

The candle burned lower, and with it went the last of their patience. Every choice had a price. The trick was knowing who would pay it. Somewhere far off, a clock struck a time that did not exist.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "We do this my way," he said, though his voice shook more than he wanted it to. "We do this my way," he said, though his voice shook more than he wanted it to.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "We do this my way," he said, though his voice shook more than he wanted it to. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

It was only the beginning.', NOW() - INTERVAL 199 HOUR),
(15, 10, 'Fire and Rain', 'The bell rang three times before anyone dared to answer it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "We do this my way," he said, though his voice shook more than he wanted it to. Somewhere far off, a clock struck a time that did not exist.

Every choice had a price. The trick was knowing who would pay it. They walked in silence until the lights of the next town appeared through the trees. A notice flickered into view, glowing faintly in the air in front of them.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. They walked in silence until the lights of the next town appeared through the trees. They walked in silence until the lights of the next town appeared through the trees.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Somewhere far off, a clock struck a time that did not exist. Footsteps echoed somewhere behind the wall, too regular to be the wind.

Footsteps echoed somewhere behind the wall, too regular to be the wind. Footsteps echoed somewhere behind the wall, too regular to be the wind. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

He smiled for the first time that day.', NOW() - INTERVAL 151 HOUR),
(15, 11, 'What Was Lost', 'Nobody had warned them that the road would end like this. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

"You knew," she whispered. "You knew all along and you said nothing." There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Somewhere far off, a clock struck a time that did not exist. "You knew," she whispered. "You knew all along and you said nothing."

Every choice had a price. The trick was knowing who would pay it. A notice flickered into view, glowing faintly in the air in front of them. Every choice had a price. The trick was knowing who would pay it.

The old stories had always said the gate would open on its own. They had never said what would walk through it. "You knew," she whispered. "You knew all along and you said nothing." "We do this my way," he said, though his voice shook more than he wanted it to.

"You knew," she whispered. "You knew all along and you said nothing." Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 103 HOUR),
(15, 12, 'The Turning Point', 'Nobody had warned them that the road would end like this. Footsteps echoed somewhere behind the wall, too regular to be the wind.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The old stories had always said the gate would open on its own. They had never said what would walk through it.

"You knew," she whispered. "You knew all along and you said nothing." "We do this my way," he said, though his voice shook more than he wanted it to. The candle burned lower, and with it went the last of their patience.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. They walked in silence until the lights of the next town appeared through the trees. "We do this my way," he said, though his voice shook more than he wanted it to.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "We do this my way," he said, though his voice shook more than he wanted it to. Footsteps echoed somewhere behind the wall, too regular to be the wind.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "We do this my way," he said, though his voice shook more than he wanted it to. The old stories had always said the gate would open on its own. They had never said what would walk through it.

And then, very quietly, the door began to open.', NOW() - INTERVAL 55 HOUR),
(16, 1, 'A Strange Beginning', 'It had been raining for nine days when the stranger arrived. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "You knew," she whispered. "You knew all along and you said nothing." Somewhere far off, a clock struck a time that did not exist.

"We do this my way," he said, though his voice shook more than he wanted it to. "We do this my way," he said, though his voice shook more than he wanted it to. Footsteps echoed somewhere behind the wall, too regular to be the wind.

Every choice had a price. The trick was knowing who would pay it. Every choice had a price. The trick was knowing who would pay it. A notice flickered into view, glowing faintly in the air in front of them.

"You knew," she whispered. "You knew all along and you said nothing." "You knew," she whispered. "You knew all along and you said nothing." A notice flickered into view, glowing faintly in the air in front of them.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Somewhere far off, a clock struck a time that did not exist. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 511 HOUR),
(16, 2, 'The First Step', 'It had been raining for nine days when the stranger arrived. "We do this my way," he said, though his voice shook more than he wanted it to.

Every choice had a price. The trick was knowing who would pay it. A notice flickered into view, glowing faintly in the air in front of them. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "We do this my way," he said, though his voice shook more than he wanted it to.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The old stories had always said the gate would open on its own. They had never said what would walk through it. Footsteps echoed somewhere behind the wall, too regular to be the wind.

The old stories had always said the gate would open on its own. They had never said what would walk through it. "We do this my way," he said, though his voice shook more than he wanted it to. The old stories had always said the gate would open on its own. They had never said what would walk through it.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. A notice flickered into view, glowing faintly in the air in front of them. A notice flickered into view, glowing faintly in the air in front of them.

It was only the beginning.', NOW() - INTERVAL 463 HOUR),
(16, 3, 'Unexpected Guests', 'The morning came slowly, grey light pooling at the edges of the window. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

"We do this my way," he said, though his voice shook more than he wanted it to. The candle burned lower, and with it went the last of their patience. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

A notice flickered into view, glowing faintly in the air in front of them. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Somewhere far off, a clock struck a time that did not exist. They walked in silence until the lights of the next town appeared through the trees.

A notice flickered into view, glowing faintly in the air in front of them. The old stories had always said the gate would open on its own. They had never said what would walk through it. "You knew," she whispered. "You knew all along and you said nothing."

"You knew," she whispered. "You knew all along and you said nothing." "You knew," she whispered. "You knew all along and you said nothing." "We do this my way," he said, though his voice shook more than he wanted it to.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 415 HOUR),
(16, 4, 'Into the Dark', 'The bell rang three times before anyone dared to answer it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Footsteps echoed somewhere behind the wall, too regular to be the wind. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Footsteps echoed somewhere behind the wall, too regular to be the wind.

Somewhere far off, a clock struck a time that did not exist. The old stories had always said the gate would open on its own. They had never said what would walk through it. Every choice had a price. The trick was knowing who would pay it.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Footsteps echoed somewhere behind the wall, too regular to be the wind. Somewhere far off, a clock struck a time that did not exist.

A notice flickered into view, glowing faintly in the air in front of them. Every choice had a price. The trick was knowing who would pay it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Every choice had a price. The trick was knowing who would pay it. Footsteps echoed somewhere behind the wall, too regular to be the wind. They walked in silence until the lights of the next town appeared through the trees.

He smiled for the first time that day.', NOW() - INTERVAL 367 HOUR),
(16, 5, 'Old Promises', 'It had been raining for nine days when the stranger arrived. "We do this my way," he said, though his voice shook more than he wanted it to.

Footsteps echoed somewhere behind the wall, too regular to be the wind. "We do this my way," he said, though his voice shook more than he wanted it to. A notice flickered into view, glowing faintly in the air in front of them.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Every choice had a price. The trick was knowing who would pay it. They walked in silence until the lights of the next town appeared through the trees.

"You knew," she whispered. "You knew all along and you said nothing." The candle burned lower, and with it went the last of their patience. The candle burned lower, and with it went the last of their patience.

Every choice had a price. The trick was knowing who would pay it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Somewhere far off, a clock struck a time that did not exist.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "We do this my way," he said, though his voice shook more than he wanted it to. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

It was only the beginning.', NOW() - INTERVAL 319 HOUR),
(16, 6, 'The Long Night', 'The morning came slowly, grey light pooling at the edges of the window. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

The old stories had always said the gate would open on its own. They had never said what would walk through it. They walked in silence until the lights of the next town appeared through the trees. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

"We do this my way," he said, though his voice shook more than he wanted it to. A notice flickered into view, glowing faintly in the air in front of them. Somewhere far off, a clock struck a time that did not exist.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. A notice flickered into view, glowing faintly in the air in front of them. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Somewhere far off, a clock struck a time that did not exist. Footsteps echoed somewhere behind the wall, too regular to be the wind.

The candle burned lower, and with it went the last of their patience. A notice flickered into view, glowing faintly in the air in front of them. They walked in silence until the lights of the next town appeared through the trees.

He smiled for the first time that day.', NOW() - INTERVAL 271 HOUR),
(16, 7, 'Broken Rules', 'The bell rang three times before anyone dared to answer it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. The old stories had always said the gate would open on its own. They had never said what would walk through it. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Every choice had a price. The trick was knowing who would pay it. "We do this my way," he said, though his voice shook more than he wanted it to. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Somewhere far off, a clock struck a time that did not exist. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Footsteps echoed somewhere behind the wall, too regular to be the wind.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "We do this my way," he said, though his voice shook more than he wanted it to. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The candle burned lower, and with it went the last of their patience. Footsteps echoed somewhere behind the wall, too regular to be the wind.

He smiled for the first time that day.', NOW() - INTERVAL 223 HOUR),
(16, 8, 'A Familiar Face', 'The bell rang three times before anyone dared to answer it. "You knew," she whispered. "You knew all along and you said nothing."

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Footsteps echoed somewhere behind the wall, too regular to be the wind. A notice flickered into view, glowing faintly in the air in front of them.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Footsteps echoed somewhere behind the wall, too regular to be the wind. "We do this my way," he said, though his voice shook more than he wanted it to.

"We do this my way," he said, though his voice shook more than he wanted it to. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. A notice flickered into view, glowing faintly in the air in front of them.

The candle burned lower, and with it went the last of their patience. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "You knew," she whispered. "You knew all along and you said nothing." Every choice had a price. The trick was knowing who would pay it.

It was only the beginning.', NOW() - INTERVAL 175 HOUR),
(16, 9, 'Crossroads', 'The morning came slowly, grey light pooling at the edges of the window. Footsteps echoed somewhere behind the wall, too regular to be the wind.

Footsteps echoed somewhere behind the wall, too regular to be the wind. Footsteps echoed somewhere behind the wall, too regular to be the wind. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

A notice flickered into view, glowing faintly in the air in front of them. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "We do this my way," he said, though his voice shook more than he wanted it to.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. The candle burned lower, and with it went the last of their patience. "You knew," she whispered. "You knew all along and you said nothing."

"You knew," she whispered. "You knew all along and you said nothing." The candle burned lower, and with it went the last of their patience. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Footsteps echoed somewhere behind the wall, too regular to be the wind. The candle burned lower, and with it went the last of their patience.

And then, very quietly, the door began to open.', NOW() - INTERVAL 127 HOUR),
(16, 10, 'Fire and Rain', 'The morning came slowly, grey light pooling at the edges of the window. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Somewhere far off, a clock struck a time that did not exist. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. A notice flickered into view, glowing faintly in the air in front of them.

"You knew," she whispered. "You knew all along and you said nothing." Every choice had a price. The trick was knowing who would pay it. A notice flickered into view, glowing faintly in the air in front of them.

Footsteps echoed somewhere behind the wall, too regular to be the wind. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "We do this my way," he said, though his voice shook more than he wanted it to.

The old stories had always said the gate would open on its own. They had never said what would walk through it. "You knew," she whispered. "You knew all along and you said nothing." There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Somewhere far off, a clock struck a time that did not exist. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. They walked in silence until the lights of the next town appeared through the trees.

It was only the beginning.', NOW() - INTERVAL 79 HOUR),
(17, 1, 'A Strange Beginning', 'It had been raining for nine days when the stranger arrived. The old stories had always said the gate would open on its own. They had never said what would walk through it.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. A notice flickered into view, glowing faintly in the air in front of them.

The candle burned lower, and with it went the last of their patience. A notice flickered into view, glowing faintly in the air in front of them. They walked in silence until the lights of the next town appeared through the trees.

"We do this my way," he said, though his voice shook more than he wanted it to. A notice flickered into view, glowing faintly in the air in front of them. Somewhere far off, a clock struck a time that did not exist.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "You knew," she whispered. "You knew all along and you said nothing."

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. They walked in silence until the lights of the next town appeared through the trees. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 577 HOUR),
(17, 2, 'The First Step', 'The morning came slowly, grey light pooling at the edges of the window. Somewhere far off, a clock struck a time that did not exist.

The old stories had always said the gate would open on its own. They had never said what would walk through it. The old stories had always said the gate would open on its own. They had never said what would walk through it. "We do this my way," he said, though his voice shook more than he wanted it to.

Somewhere far off, a clock struck a time that did not exist. Footsteps echoed somewhere behind the wall, too regular to be the wind. "We do this my way," he said, though his voice shook more than he wanted it to.

Footsteps echoed somewhere behind the wall, too regular to be the wind. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. A notice flickered into view, glowing faintly in the air in front of them.

A notice flickered into view, glowing faintly in the air in front of them. Somewhere far off, a clock struck a time that did not exist. They walked in silence until the lights of the next town appeared through the trees.

A notice flickered into view, glowing faintly in the air in front of them. Somewhere far off, a clock struck a time that did not exist. Every choice had a price. The trick was knowing who would pay it.

He smiled for the first time that day.', NOW() - INTERVAL 529 HOUR),
(17, 3, 'Unexpected Guests', 'The morning came slowly, grey light pooling at the edges of the window. They walked in silence until the lights of the next town appeared through the trees.

Footsteps echoed somewhere behind the wall, too regular to be the wind. Footsteps echoed somewhere behind the wall, too regular to be the wind. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

A notice flickered into view, glowing faintly in the air in front of them. Every choice had a price. The trick was knowing who would pay it. Somewhere far off, a clock struck a time that did not exist.

"We do this my way," he said, though his voice shook more than he wanted it to. A notice flickered into view, glowing faintly in the air in front of them. Every choice had a price. The trick was knowing who would pay it.

"You knew," she whispered. "You knew all along and you said nothing." A notice flickered into view, glowing faintly in the air in front of them. The candle burned lower, and with it went the last of their patience.

Footsteps echoed somewhere behind the wall, too regular to be the wind. Every choice had a price. The trick was knowing who would pay it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

He smiled for the first time that day.', NOW() - INTERVAL 481 HOUR),
(17, 4, 'Into the Dark', 'Nobody had warned them that the road would end like this. "We do this my way," he said, though his voice shook more than he wanted it to.

The candle burned lower, and with it went the last of their patience. Somewhere far off, a clock struck a time that did not exist. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

The candle burned lower, and with it went the last of their patience. They walked in silence until the lights of the next town appeared through the trees. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Every choice had a price. The trick was knowing who would pay it. "We do this my way," he said, though his voice shook more than he wanted it to. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Every choice had a price. The trick was knowing who would pay it. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "We do this my way," he said, though his voice shook more than he wanted it to.

The candle burned lower, and with it went the last of their patience. "You knew," she whispered. "You knew all along and you said nothing." They walked in silence until the lights of the next town appeared through the trees.

He smiled for the first time that day.', NOW() - INTERVAL 433 HOUR),
(17, 5, 'Old Promises', 'The morning came slowly, grey light pooling at the edges of the window. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

The old stories had always said the gate would open on its own. They had never said what would walk through it. The candle burned lower, and with it went the last of their patience. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Somewhere far off, a clock struck a time that did not exist. Every choice had a price. The trick was knowing who would pay it. "You knew," she whispered. "You knew all along and you said nothing."

"We do this my way," he said, though his voice shook more than he wanted it to. Every choice had a price. The trick was knowing who would pay it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. A notice flickered into view, glowing faintly in the air in front of them. The candle burned lower, and with it went the last of their patience.

"You knew," she whispered. "You knew all along and you said nothing." Footsteps echoed somewhere behind the wall, too regular to be the wind. The candle burned lower, and with it went the last of their patience.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 385 HOUR),
(17, 6, 'The Long Night', 'It had been raining for nine days when the stranger arrived. Somewhere far off, a clock struck a time that did not exist.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. A notice flickered into view, glowing faintly in the air in front of them. Footsteps echoed somewhere behind the wall, too regular to be the wind.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Footsteps echoed somewhere behind the wall, too regular to be the wind. "We do this my way," he said, though his voice shook more than he wanted it to.

A notice flickered into view, glowing faintly in the air in front of them. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Footsteps echoed somewhere behind the wall, too regular to be the wind.

Somewhere far off, a clock struck a time that did not exist. They walked in silence until the lights of the next town appeared through the trees. "We do this my way," he said, though his voice shook more than he wanted it to.

"We do this my way," he said, though his voice shook more than he wanted it to. A notice flickered into view, glowing faintly in the air in front of them. Footsteps echoed somewhere behind the wall, too regular to be the wind.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 337 HOUR),
(17, 7, 'Broken Rules', 'The bell rang three times before anyone dared to answer it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

A notice flickered into view, glowing faintly in the air in front of them. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "We do this my way," he said, though his voice shook more than he wanted it to.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "You knew," she whispered. "You knew all along and you said nothing." There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. A notice flickered into view, glowing faintly in the air in front of them. Somewhere far off, a clock struck a time that did not exist.

"We do this my way," he said, though his voice shook more than he wanted it to. "You knew," she whispered. "You knew all along and you said nothing." There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

The old stories had always said the gate would open on its own. They had never said what would walk through it. A notice flickered into view, glowing faintly in the air in front of them. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

And then, very quietly, the door began to open.', NOW() - INTERVAL 289 HOUR),
(17, 8, 'A Familiar Face', 'The morning came slowly, grey light pooling at the edges of the window. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Somewhere far off, a clock struck a time that did not exist. The old stories had always said the gate would open on its own. They had never said what would walk through it. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Every choice had a price. The trick was knowing who would pay it. "You knew," she whispered. "You knew all along and you said nothing."

"You knew," she whispered. "You knew all along and you said nothing." "You knew," she whispered. "You knew all along and you said nothing." Somewhere far off, a clock struck a time that did not exist.

Somewhere far off, a clock struck a time that did not exist. They walked in silence until the lights of the next town appeared through the trees. "You knew," she whispered. "You knew all along and you said nothing."

The candle burned lower, and with it went the last of their patience. A notice flickered into view, glowing faintly in the air in front of them. A notice flickered into view, glowing faintly in the air in front of them.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 241 HOUR),
(17, 9, 'Crossroads', 'For the first time in years, the city was completely silent. Somewhere far off, a clock struck a time that did not exist.

"We do this my way," he said, though his voice shook more than he wanted it to. The old stories had always said the gate would open on its own. They had never said what would walk through it. A notice flickered into view, glowing faintly in the air in front of them.

The old stories had always said the gate would open on its own. They had never said what would walk through it. "You knew," she whispered. "You knew all along and you said nothing." She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

They walked in silence until the lights of the next town appeared through the trees. The candle burned lower, and with it went the last of their patience. Somewhere far off, a clock struck a time that did not exist.

Somewhere far off, a clock struck a time that did not exist. "We do this my way," he said, though his voice shook more than he wanted it to. Somewhere far off, a clock struck a time that did not exist.

"You knew," she whispered. "You knew all along and you said nothing." A notice flickered into view, glowing faintly in the air in front of them. Footsteps echoed somewhere behind the wall, too regular to be the wind.

It was only the beginning.', NOW() - INTERVAL 193 HOUR),
(17, 10, 'Fire and Rain', 'The morning came slowly, grey light pooling at the edges of the window. They walked in silence until the lights of the next town appeared through the trees.

Somewhere far off, a clock struck a time that did not exist. "You knew," she whispered. "You knew all along and you said nothing." "We do this my way," he said, though his voice shook more than he wanted it to.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. They walked in silence until the lights of the next town appeared through the trees. Footsteps echoed somewhere behind the wall, too regular to be the wind.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. A notice flickered into view, glowing faintly in the air in front of them. The old stories had always said the gate would open on its own. They had never said what would walk through it.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "We do this my way," he said, though his voice shook more than he wanted it to. "You knew," she whispered. "You knew all along and you said nothing."

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The candle burned lower, and with it went the last of their patience.

It was only the beginning.', NOW() - INTERVAL 145 HOUR),
(17, 11, 'What Was Lost', 'It had been raining for nine days when the stranger arrived. The candle burned lower, and with it went the last of their patience.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "We do this my way," he said, though his voice shook more than he wanted it to.

Every choice had a price. The trick was knowing who would pay it. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The candle burned lower, and with it went the last of their patience.

The old stories had always said the gate would open on its own. They had never said what would walk through it. "We do this my way," he said, though his voice shook more than he wanted it to. "You knew," she whispered. "You knew all along and you said nothing."

Footsteps echoed somewhere behind the wall, too regular to be the wind. "You knew," she whispered. "You knew all along and you said nothing." The old stories had always said the gate would open on its own. They had never said what would walk through it.

The candle burned lower, and with it went the last of their patience. The old stories had always said the gate would open on its own. They had never said what would walk through it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

He smiled for the first time that day.', NOW() - INTERVAL 97 HOUR),
(17, 12, 'The Turning Point', 'For the first time in years, the city was completely silent. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Footsteps echoed somewhere behind the wall, too regular to be the wind. Every choice had a price. The trick was knowing who would pay it.

Footsteps echoed somewhere behind the wall, too regular to be the wind. The old stories had always said the gate would open on its own. They had never said what would walk through it. The old stories had always said the gate would open on its own. They had never said what would walk through it.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Footsteps echoed somewhere behind the wall, too regular to be the wind. "You knew," she whispered. "You knew all along and you said nothing."

Footsteps echoed somewhere behind the wall, too regular to be the wind. "You knew," she whispered. "You knew all along and you said nothing." "We do this my way," he said, though his voice shook more than he wanted it to.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

And then, very quietly, the door began to open.', NOW() - INTERVAL 49 HOUR),
(18, 1, 'A Strange Beginning', 'Nobody had warned them that the road would end like this. A notice flickered into view, glowing faintly in the air in front of them.

"You knew," she whispered. "You knew all along and you said nothing." She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. They walked in silence until the lights of the next town appeared through the trees.

They walked in silence until the lights of the next town appeared through the trees. The old stories had always said the gate would open on its own. They had never said what would walk through it. "You knew," she whispered. "You knew all along and you said nothing."

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. The candle burned lower, and with it went the last of their patience. The old stories had always said the gate would open on its own. They had never said what would walk through it.

The candle burned lower, and with it went the last of their patience. The old stories had always said the gate would open on its own. They had never said what would walk through it. "We do this my way," he said, though his voice shook more than he wanted it to.

"You knew," she whispered. "You knew all along and you said nothing." The old stories had always said the gate would open on its own. They had never said what would walk through it. A notice flickered into view, glowing faintly in the air in front of them.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 249 HOUR),
(18, 2, 'The First Step', 'Nobody had warned them that the road would end like this. "We do this my way," he said, though his voice shook more than he wanted it to.

The old stories had always said the gate would open on its own. They had never said what would walk through it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

"You knew," she whispered. "You knew all along and you said nothing." A notice flickered into view, glowing faintly in the air in front of them. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Every choice had a price. The trick was knowing who would pay it. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. They walked in silence until the lights of the next town appeared through the trees.

Somewhere far off, a clock struck a time that did not exist. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "You knew," she whispered. "You knew all along and you said nothing."

Every choice had a price. The trick was knowing who would pay it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "You knew," she whispered. "You knew all along and you said nothing."

He smiled for the first time that day.', NOW() - INTERVAL 201 HOUR),
(18, 3, 'Unexpected Guests', 'It had been raining for nine days when the stranger arrived. The candle burned lower, and with it went the last of their patience.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "You knew," she whispered. "You knew all along and you said nothing." The old stories had always said the gate would open on its own. They had never said what would walk through it.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "We do this my way," he said, though his voice shook more than he wanted it to.

Somewhere far off, a clock struck a time that did not exist. They walked in silence until the lights of the next town appeared through the trees. The old stories had always said the gate would open on its own. They had never said what would walk through it.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Every choice had a price. The trick was knowing who would pay it. The old stories had always said the gate would open on its own. They had never said what would walk through it.

They walked in silence until the lights of the next town appeared through the trees. The old stories had always said the gate would open on its own. They had never said what would walk through it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

And then, very quietly, the door began to open.', NOW() - INTERVAL 153 HOUR),
(18, 4, 'Into the Dark', 'The bell rang three times before anyone dared to answer it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

The candle burned lower, and with it went the last of their patience. Somewhere far off, a clock struck a time that did not exist. They walked in silence until the lights of the next town appeared through the trees.

"We do this my way," he said, though his voice shook more than he wanted it to. The candle burned lower, and with it went the last of their patience. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

A notice flickered into view, glowing faintly in the air in front of them. "We do this my way," he said, though his voice shook more than he wanted it to. "You knew," she whispered. "You knew all along and you said nothing."

Every choice had a price. The trick was knowing who would pay it. A notice flickered into view, glowing faintly in the air in front of them. The candle burned lower, and with it went the last of their patience.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Footsteps echoed somewhere behind the wall, too regular to be the wind. The candle burned lower, and with it went the last of their patience.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 105 HOUR),
(18, 5, 'Old Promises', 'It had been raining for nine days when the stranger arrived. A notice flickered into view, glowing faintly in the air in front of them.

"You knew," she whispered. "You knew all along and you said nothing." "You knew," she whispered. "You knew all along and you said nothing." They walked in silence until the lights of the next town appeared through the trees.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "We do this my way," he said, though his voice shook more than he wanted it to. Somewhere far off, a clock struck a time that did not exist.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. The candle burned lower, and with it went the last of their patience. "You knew," she whispered. "You knew all along and you said nothing."

Footsteps echoed somewhere behind the wall, too regular to be the wind. The candle burned lower, and with it went the last of their patience. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

They walked in silence until the lights of the next town appeared through the trees. "We do this my way," he said, though his voice shook more than he wanted it to. Every choice had a price. The trick was knowing who would pay it.

It was only the beginning.', NOW() - INTERVAL 57 HOUR),
(19, 1, 'A Strange Beginning', 'The morning came slowly, grey light pooling at the edges of the window. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Every choice had a price. The trick was knowing who would pay it. "You knew," she whispered. "You knew all along and you said nothing."

They walked in silence until the lights of the next town appeared through the trees. Footsteps echoed somewhere behind the wall, too regular to be the wind. "You knew," she whispered. "You knew all along and you said nothing."

The candle burned lower, and with it went the last of their patience. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Somewhere far off, a clock struck a time that did not exist.

The old stories had always said the gate would open on its own. They had never said what would walk through it. They walked in silence until the lights of the next town appeared through the trees. They walked in silence until the lights of the next town appeared through the trees.

Somewhere far off, a clock struck a time that did not exist. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Somewhere far off, a clock struck a time that did not exist.

And then, very quietly, the door began to open.', NOW() - INTERVAL 426 HOUR),
(19, 2, 'The First Step', 'Nobody had warned them that the road would end like this. The old stories had always said the gate would open on its own. They had never said what would walk through it.

"You knew," she whispered. "You knew all along and you said nothing." The old stories had always said the gate would open on its own. They had never said what would walk through it. Somewhere far off, a clock struck a time that did not exist.

A notice flickered into view, glowing faintly in the air in front of them. The candle burned lower, and with it went the last of their patience. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. They walked in silence until the lights of the next town appeared through the trees.

"We do this my way," he said, though his voice shook more than he wanted it to. They walked in silence until the lights of the next town appeared through the trees. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Footsteps echoed somewhere behind the wall, too regular to be the wind. Every choice had a price. The trick was knowing who would pay it. They walked in silence until the lights of the next town appeared through the trees.

Tomorrow, they would find out whether it had all been worth it.', NOW() - INTERVAL 378 HOUR),
(19, 3, 'Unexpected Guests', 'For the first time in years, the city was completely silent. They walked in silence until the lights of the next town appeared through the trees.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. They walked in silence until the lights of the next town appeared through the trees. The old stories had always said the gate would open on its own. They had never said what would walk through it.

The candle burned lower, and with it went the last of their patience. Every choice had a price. The trick was knowing who would pay it. A notice flickered into view, glowing faintly in the air in front of them.

A notice flickered into view, glowing faintly in the air in front of them. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

A notice flickered into view, glowing faintly in the air in front of them. Footsteps echoed somewhere behind the wall, too regular to be the wind. Footsteps echoed somewhere behind the wall, too regular to be the wind.

"You knew," she whispered. "You knew all along and you said nothing." Every choice had a price. The trick was knowing who would pay it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

And then, very quietly, the door began to open.', NOW() - INTERVAL 330 HOUR),
(19, 4, 'Into the Dark', 'It had been raining for nine days when the stranger arrived. Every choice had a price. The trick was knowing who would pay it.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. The candle burned lower, and with it went the last of their patience. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Footsteps echoed somewhere behind the wall, too regular to be the wind. A notice flickered into view, glowing faintly in the air in front of them. They walked in silence until the lights of the next town appeared through the trees.

Every choice had a price. The trick was knowing who would pay it. Somewhere far off, a clock struck a time that did not exist. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Footsteps echoed somewhere behind the wall, too regular to be the wind. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Somewhere far off, a clock struck a time that did not exist.

Every choice had a price. The trick was knowing who would pay it. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "We do this my way," he said, though his voice shook more than he wanted it to.

He smiled for the first time that day.', NOW() - INTERVAL 282 HOUR),
(19, 5, 'Old Promises', 'The bell rang three times before anyone dared to answer it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

They walked in silence until the lights of the next town appeared through the trees. Every choice had a price. The trick was knowing who would pay it. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

They walked in silence until the lights of the next town appeared through the trees. Every choice had a price. The trick was knowing who would pay it. They walked in silence until the lights of the next town appeared through the trees.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. The old stories had always said the gate would open on its own. They had never said what would walk through it. "We do this my way," he said, though his voice shook more than he wanted it to.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "You knew," she whispered. "You knew all along and you said nothing." Somewhere far off, a clock struck a time that did not exist.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "You knew," she whispered. "You knew all along and you said nothing." A notice flickered into view, glowing faintly in the air in front of them.

He smiled for the first time that day.', NOW() - INTERVAL 234 HOUR),
(19, 6, 'The Long Night', 'It had been raining for nine days when the stranger arrived. Every choice had a price. The trick was knowing who would pay it.

Footsteps echoed somewhere behind the wall, too regular to be the wind. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. A notice flickered into view, glowing faintly in the air in front of them.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "We do this my way," he said, though his voice shook more than he wanted it to. Somewhere far off, a clock struck a time that did not exist.

The candle burned lower, and with it went the last of their patience. "You knew," she whispered. "You knew all along and you said nothing." Footsteps echoed somewhere behind the wall, too regular to be the wind.

Every choice had a price. The trick was knowing who would pay it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

"You knew," she whispered. "You knew all along and you said nothing." "You knew," she whispered. "You knew all along and you said nothing." Somewhere far off, a clock struck a time that did not exist.

He smiled for the first time that day.', NOW() - INTERVAL 186 HOUR),
(19, 7, 'Broken Rules', 'The bell rang three times before anyone dared to answer it. The candle burned lower, and with it went the last of their patience.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. The candle burned lower, and with it went the last of their patience. "You knew," she whispered. "You knew all along and you said nothing."

The candle burned lower, and with it went the last of their patience. "You knew," she whispered. "You knew all along and you said nothing." There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Footsteps echoed somewhere behind the wall, too regular to be the wind. Somewhere far off, a clock struck a time that did not exist. A notice flickered into view, glowing faintly in the air in front of them.

"You knew," she whispered. "You knew all along and you said nothing." Every choice had a price. The trick was knowing who would pay it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Every choice had a price. The trick was knowing who would pay it. The candle burned lower, and with it went the last of their patience. Somewhere far off, a clock struck a time that did not exist.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 138 HOUR),
(19, 8, 'A Familiar Face', 'The morning came slowly, grey light pooling at the edges of the window. The candle burned lower, and with it went the last of their patience.

"You knew," she whispered. "You knew all along and you said nothing." They walked in silence until the lights of the next town appeared through the trees. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Every choice had a price. The trick was knowing who would pay it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

They walked in silence until the lights of the next town appeared through the trees. A notice flickered into view, glowing faintly in the air in front of them. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Somewhere far off, a clock struck a time that did not exist. The candle burned lower, and with it went the last of their patience.

The candle burned lower, and with it went the last of their patience. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Footsteps echoed somewhere behind the wall, too regular to be the wind.

And then, very quietly, the door began to open.', NOW() - INTERVAL 90 HOUR),
(20, 1, 'A Strange Beginning', 'It had been raining for nine days when the stranger arrived. Every choice had a price. The trick was knowing who would pay it.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "We do this my way," he said, though his voice shook more than he wanted it to.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. They walked in silence until the lights of the next town appeared through the trees. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

"We do this my way," he said, though his voice shook more than he wanted it to. They walked in silence until the lights of the next town appeared through the trees. Somewhere far off, a clock struck a time that did not exist.

"We do this my way," he said, though his voice shook more than he wanted it to. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

It was only the beginning.', NOW() - INTERVAL 619 HOUR),
(20, 2, 'The First Step', 'The morning came slowly, grey light pooling at the edges of the window. "You knew," she whispered. "You knew all along and you said nothing."

They walked in silence until the lights of the next town appeared through the trees. The old stories had always said the gate would open on its own. They had never said what would walk through it. Footsteps echoed somewhere behind the wall, too regular to be the wind.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. They walked in silence until the lights of the next town appeared through the trees. "You knew," she whispered. "You knew all along and you said nothing."

"We do this my way," he said, though his voice shook more than he wanted it to. Footsteps echoed somewhere behind the wall, too regular to be the wind. "We do this my way," he said, though his voice shook more than he wanted it to.

"We do this my way," he said, though his voice shook more than he wanted it to. "We do this my way," he said, though his voice shook more than he wanted it to. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Somewhere far off, a clock struck a time that did not exist. Footsteps echoed somewhere behind the wall, too regular to be the wind.

And then, very quietly, the door began to open.', NOW() - INTERVAL 571 HOUR),
(20, 3, 'Unexpected Guests', 'For the first time in years, the city was completely silent. "We do this my way," he said, though his voice shook more than he wanted it to.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Footsteps echoed somewhere behind the wall, too regular to be the wind. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Every choice had a price. The trick was knowing who would pay it. Every choice had a price. The trick was knowing who would pay it. "You knew," she whispered. "You knew all along and you said nothing."

"We do this my way," he said, though his voice shook more than he wanted it to. Footsteps echoed somewhere behind the wall, too regular to be the wind. Every choice had a price. The trick was knowing who would pay it.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. The candle burned lower, and with it went the last of their patience. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Every choice had a price. The trick was knowing who would pay it. "You knew," she whispered. "You knew all along and you said nothing."

It was only the beginning.', NOW() - INTERVAL 523 HOUR),
(20, 4, 'Into the Dark', 'For the first time in years, the city was completely silent. A notice flickered into view, glowing faintly in the air in front of them.

Every choice had a price. The trick was knowing who would pay it. "We do this my way," he said, though his voice shook more than he wanted it to. Footsteps echoed somewhere behind the wall, too regular to be the wind.

They walked in silence until the lights of the next town appeared through the trees. Every choice had a price. The trick was knowing who would pay it. Somewhere far off, a clock struck a time that did not exist.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The candle burned lower, and with it went the last of their patience. Footsteps echoed somewhere behind the wall, too regular to be the wind.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. The candle burned lower, and with it went the last of their patience. Footsteps echoed somewhere behind the wall, too regular to be the wind.

They walked in silence until the lights of the next town appeared through the trees. Somewhere far off, a clock struck a time that did not exist. The old stories had always said the gate would open on its own. They had never said what would walk through it.

And then, very quietly, the door began to open.', NOW() - INTERVAL 475 HOUR),
(20, 5, 'Old Promises', 'The bell rang three times before anyone dared to answer it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

The old stories had always said the gate would open on its own. They had never said what would walk through it. A notice flickered into view, glowing faintly in the air in front of them. The candle burned lower, and with it went the last of their patience.

"You knew," she whispered. "You knew all along and you said nothing." Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Somewhere far off, a clock struck a time that did not exist.

They walked in silence until the lights of the next town appeared through the trees. The candle burned lower, and with it went the last of their patience. "You knew," she whispered. "You knew all along and you said nothing."

A notice flickered into view, glowing faintly in the air in front of them. A notice flickered into view, glowing faintly in the air in front of them. Somewhere far off, a clock struck a time that did not exist.

A notice flickered into view, glowing faintly in the air in front of them. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 427 HOUR),
(20, 6, 'The Long Night', 'The bell rang three times before anyone dared to answer it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Footsteps echoed somewhere behind the wall, too regular to be the wind. "We do this my way," he said, though his voice shook more than he wanted it to.

"We do this my way," he said, though his voice shook more than he wanted it to. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Every choice had a price. The trick was knowing who would pay it.

"You knew," she whispered. "You knew all along and you said nothing." A notice flickered into view, glowing faintly in the air in front of them. The old stories had always said the gate would open on its own. They had never said what would walk through it.

Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Every choice had a price. The trick was knowing who would pay it. They walked in silence until the lights of the next town appeared through the trees.

The candle burned lower, and with it went the last of their patience. A notice flickered into view, glowing faintly in the air in front of them. "We do this my way," he said, though his voice shook more than he wanted it to.

And then, very quietly, the door began to open.', NOW() - INTERVAL 379 HOUR),
(20, 7, 'Broken Rules', 'The morning came slowly, grey light pooling at the edges of the window. "You knew," she whispered. "You knew all along and you said nothing."

Somewhere far off, a clock struck a time that did not exist. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Footsteps echoed somewhere behind the wall, too regular to be the wind.

"We do this my way," he said, though his voice shook more than he wanted it to. "You knew," she whispered. "You knew all along and you said nothing." Somewhere far off, a clock struck a time that did not exist.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. The old stories had always said the gate would open on its own. They had never said what would walk through it. The candle burned lower, and with it went the last of their patience.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. "You knew," she whispered. "You knew all along and you said nothing."

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. "We do this my way," he said, though his voice shook more than he wanted it to. Somewhere far off, a clock struck a time that did not exist.

He smiled for the first time that day.', NOW() - INTERVAL 331 HOUR),
(20, 8, 'A Familiar Face', 'For the first time in years, the city was completely silent. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

Somewhere far off, a clock struck a time that did not exist. "We do this my way," he said, though his voice shook more than he wanted it to. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Footsteps echoed somewhere behind the wall, too regular to be the wind. "You knew," she whispered. "You knew all along and you said nothing."

Every choice had a price. The trick was knowing who would pay it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. A notice flickered into view, glowing faintly in the air in front of them.

The candle burned lower, and with it went the last of their patience. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. They walked in silence until the lights of the next town appeared through the trees.

They walked in silence until the lights of the next town appeared through the trees. Every choice had a price. The trick was knowing who would pay it. "You knew," she whispered. "You knew all along and you said nothing."

And then, very quietly, the door began to open.', NOW() - INTERVAL 283 HOUR),
(20, 9, 'Crossroads', 'For the first time in years, the city was completely silent. They walked in silence until the lights of the next town appeared through the trees.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Footsteps echoed somewhere behind the wall, too regular to be the wind. A notice flickered into view, glowing faintly in the air in front of them.

A notice flickered into view, glowing faintly in the air in front of them. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. "We do this my way," he said, though his voice shook more than he wanted it to.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

The old stories had always said the gate would open on its own. They had never said what would walk through it. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

Footsteps echoed somewhere behind the wall, too regular to be the wind. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. Every choice had a price. The trick was knowing who would pay it.

By the time the sun went down, nothing would ever be the same again.', NOW() - INTERVAL 235 HOUR),
(20, 10, 'Fire and Rain', 'The morning came slowly, grey light pooling at the edges of the window. Every choice had a price. The trick was knowing who would pay it.

Every choice had a price. The trick was knowing who would pay it. The candle burned lower, and with it went the last of their patience. "You knew," she whispered. "You knew all along and you said nothing."

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. The candle burned lower, and with it went the last of their patience. "We do this my way," he said, though his voice shook more than he wanted it to.

Every choice had a price. The trick was knowing who would pay it. Somewhere far off, a clock struck a time that did not exist. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

The candle burned lower, and with it went the last of their patience. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

"You knew," she whispered. "You knew all along and you said nothing." The candle burned lower, and with it went the last of their patience. "We do this my way," he said, though his voice shook more than he wanted it to.

He smiled for the first time that day.', NOW() - INTERVAL 187 HOUR),
(20, 11, 'What Was Lost', 'It had been raining for nine days when the stranger arrived. "You knew," she whispered. "You knew all along and you said nothing."

The old stories had always said the gate would open on its own. They had never said what would walk through it. The old stories had always said the gate would open on its own. They had never said what would walk through it. The old stories had always said the gate would open on its own. They had never said what would walk through it.

A notice flickered into view, glowing faintly in the air in front of them. The old stories had always said the gate would open on its own. They had never said what would walk through it. "We do this my way," he said, though his voice shook more than he wanted it to.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Every choice had a price. The trick was knowing who would pay it.

Every choice had a price. The trick was knowing who would pay it. A notice flickered into view, glowing faintly in the air in front of them. Footsteps echoed somewhere behind the wall, too regular to be the wind.

They walked in silence until the lights of the next town appeared through the trees. Every choice had a price. The trick was knowing who would pay it. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

And then, very quietly, the door began to open.', NOW() - INTERVAL 139 HOUR),
(20, 12, 'The Turning Point', 'Nobody had warned them that the road would end like this. Somewhere far off, a clock struck a time that did not exist.

There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

The old stories had always said the gate would open on its own. They had never said what would walk through it. The candle burned lower, and with it went the last of their patience. Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong.

"You knew," she whispered. "You knew all along and you said nothing." Laughter drifted up from the street below, warm and careless, as if nothing in the world was wrong. There was a smell of iron and wet stone, and beneath it something sweeter that did not belong.

"We do this my way," he said, though his voice shook more than he wanted it to. Somewhere far off, a clock struck a time that did not exist. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter.

She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. She folded the map twice and tucked it into her coat, as if hiding it could make the path shorter. Footsteps echoed somewhere behind the wall, too regular to be the wind.

And then, very quietly, the door began to open.', NOW() - INTERVAL 91 HOUR);

INSERT INTO book_views_daily (book_id, view_date, views) VALUES
(1, CURDATE() - INTERVAL 0 DAY, 15207),
(1, CURDATE() - INTERVAL 1 DAY, 7398),
(1, CURDATE() - INTERVAL 2 DAY, 20276),
(1, CURDATE() - INTERVAL 3 DAY, 12056),
(1, CURDATE() - INTERVAL 4 DAY, 8768),
(1, CURDATE() - INTERVAL 5 DAY, 18084),
(1, CURDATE() - INTERVAL 6 DAY, 19591),
(2, CURDATE() - INTERVAL 0 DAY, 9044),
(2, CURDATE() - INTERVAL 1 DAY, 5016),
(2, CURDATE() - INTERVAL 2 DAY, 10868),
(2, CURDATE() - INTERVAL 3 DAY, 3952),
(2, CURDATE() - INTERVAL 4 DAY, 9804),
(2, CURDATE() - INTERVAL 5 DAY, 12008),
(2, CURDATE() - INTERVAL 6 DAY, 8132),
(3, CURDATE() - INTERVAL 0 DAY, 5684),
(3, CURDATE() - INTERVAL 1 DAY, 4655),
(3, CURDATE() - INTERVAL 2 DAY, 3822),
(3, CURDATE() - INTERVAL 3 DAY, 6958),
(3, CURDATE() - INTERVAL 4 DAY, 5635),
(3, CURDATE() - INTERVAL 5 DAY, 5243),
(3, CURDATE() - INTERVAL 6 DAY, 3773),
(4, CURDATE() - INTERVAL 0 DAY, 4300),
(4, CURDATE() - INTERVAL 1 DAY, 2379),
(4, CURDATE() - INTERVAL 2 DAY, 3233),
(4, CURDATE() - INTERVAL 3 DAY, 1250),
(4, CURDATE() - INTERVAL 4 DAY, 2104),
(4, CURDATE() - INTERVAL 5 DAY, 3080),
(4, CURDATE() - INTERVAL 6 DAY, 1342),
(5, CURDATE() - INTERVAL 0 DAY, 3036),
(5, CURDATE() - INTERVAL 1 DAY, 1804),
(5, CURDATE() - INTERVAL 2 DAY, 2970),
(5, CURDATE() - INTERVAL 3 DAY, 1122),
(5, CURDATE() - INTERVAL 4 DAY, 2684),
(5, CURDATE() - INTERVAL 5 DAY, 1210),
(5, CURDATE() - INTERVAL 6 DAY, 3058),
(6, CURDATE() - INTERVAL 0 DAY, 1261),
(6, CURDATE() - INTERVAL 1 DAY, 884),
(6, CURDATE() - INTERVAL 2 DAY, 783),
(6, CURDATE() - INTERVAL 3 DAY, 2189),
(6, CURDATE() - INTERVAL 4 DAY, 1522),
(6, CURDATE() - INTERVAL 5 DAY, 2233),
(6, CURDATE() - INTERVAL 6 DAY, 1116),
(7, CURDATE() - INTERVAL 0 DAY, 714),
(7, CURDATE() - INTERVAL 1 DAY, 799),
(7, CURDATE() - INTERVAL 2 DAY, 858),
(7, CURDATE() - INTERVAL 3 DAY, 986),
(7, CURDATE() - INTERVAL 4 DAY, 960),
(7, CURDATE() - INTERVAL 5 DAY, 773),
(7, CURDATE() - INTERVAL 6 DAY, 1071),
(8, CURDATE() - INTERVAL 0 DAY, 450),
(8, CURDATE() - INTERVAL 1 DAY, 558),
(8, CURDATE() - INTERVAL 2 DAY, 269),
(8, CURDATE() - INTERVAL 3 DAY, 637),
(8, CURDATE() - INTERVAL 4 DAY, 705),
(8, CURDATE() - INTERVAL 5 DAY, 367),
(8, CURDATE() - INTERVAL 6 DAY, 563),
(9, CURDATE() - INTERVAL 0 DAY, 166),
(9, CURDATE() - INTERVAL 1 DAY, 160),
(9, CURDATE() - INTERVAL 2 DAY, 292),
(9, CURDATE() - INTERVAL 3 DAY, 176),
(9, CURDATE() - INTERVAL 4 DAY, 295),
(9, CURDATE() - INTERVAL 5 DAY, 372),
(9, CURDATE() - INTERVAL 6 DAY, 449),
(10, CURDATE() - INTERVAL 0 DAY, 161),
(10, CURDATE() - INTERVAL 1 DAY, 90),
(10, CURDATE() - INTERVAL 2 DAY, 248),
(10, CURDATE() - INTERVAL 3 DAY, 229),
(10, CURDATE() - INTERVAL 4 DAY, 246),
(10, CURDATE() - INTERVAL 5 DAY, 241),
(10, CURDATE() - INTERVAL 6 DAY, 94),
(11, CURDATE() - INTERVAL 0 DAY, 231),
(11, CURDATE() - INTERVAL 1 DAY, 173),
(11, CURDATE() - INTERVAL 2 DAY, 106),
(11, CURDATE() - INTERVAL 3 DAY, 279),
(11, CURDATE() - INTERVAL 4 DAY, 125),
(11, CURDATE() - INTERVAL 5 DAY, 76),
(11, CURDATE() - INTERVAL 6 DAY, 118),
(12, CURDATE() - INTERVAL 0 DAY, 192),
(12, CURDATE() - INTERVAL 1 DAY, 159),
(12, CURDATE() - INTERVAL 2 DAY, 104),
(12, CURDATE() - INTERVAL 3 DAY, 98),
(12, CURDATE() - INTERVAL 4 DAY, 216),
(12, CURDATE() - INTERVAL 5 DAY, 99),
(12, CURDATE() - INTERVAL 6 DAY, 199),
(13, CURDATE() - INTERVAL 0 DAY, 180),
(13, CURDATE() - INTERVAL 1 DAY, 121),
(13, CURDATE() - INTERVAL 2 DAY, 53),
(13, CURDATE() - INTERVAL 3 DAY, 53),
(13, CURDATE() - INTERVAL 4 DAY, 73),
(13, CURDATE() - INTERVAL 5 DAY, 160),
(13, CURDATE() - INTERVAL 6 DAY, 138),
(14, CURDATE() - INTERVAL 0 DAY, 109),
(14, CURDATE() - INTERVAL 1 DAY, 80),
(14, CURDATE() - INTERVAL 2 DAY, 110),
(14, CURDATE() - INTERVAL 3 DAY, 67),
(14, CURDATE() - INTERVAL 4 DAY, 122),
(14, CURDATE() - INTERVAL 5 DAY, 114),
(14, CURDATE() - INTERVAL 6 DAY, 155),
(15, CURDATE() - INTERVAL 0 DAY, 70),
(15, CURDATE() - INTERVAL 1 DAY, 141),
(15, CURDATE() - INTERVAL 2 DAY, 114),
(15, CURDATE() - INTERVAL 3 DAY, 75),
(15, CURDATE() - INTERVAL 4 DAY, 98),
(15, CURDATE() - INTERVAL 5 DAY, 47),
(15, CURDATE() - INTERVAL 6 DAY, 132),
(16, CURDATE() - INTERVAL 0 DAY, 78),
(16, CURDATE() - INTERVAL 1 DAY, 98),
(16, CURDATE() - INTERVAL 2 DAY, 97),
(16, CURDATE() - INTERVAL 3 DAY, 94),
(16, CURDATE() - INTERVAL 4 DAY, 53),
(16, CURDATE() - INTERVAL 5 DAY, 88),
(16, CURDATE() - INTERVAL 6 DAY, 37),
(17, CURDATE() - INTERVAL 0 DAY, 85),
(17, CURDATE() - INTERVAL 1 DAY, 82),
(17, CURDATE() - INTERVAL 2 DAY, 78),
(17, CURDATE() - INTERVAL 3 DAY, 87),
(17, CURDATE() - INTERVAL 4 DAY, 60),
(17, CURDATE() - INTERVAL 5 DAY, 64),
(17, CURDATE() - INTERVAL 6 DAY, 54),
(18, CURDATE() - INTERVAL 0 DAY, 35),
(18, CURDATE() - INTERVAL 1 DAY, 50),
(18, CURDATE() - INTERVAL 2 DAY, 54),
(18, CURDATE() - INTERVAL 3 DAY, 22),
(18, CURDATE() - INTERVAL 4 DAY, 19),
(18, CURDATE() - INTERVAL 5 DAY, 47),
(18, CURDATE() - INTERVAL 6 DAY, 59),
(19, CURDATE() - INTERVAL 0 DAY, 17),
(19, CURDATE() - INTERVAL 1 DAY, 24),
(19, CURDATE() - INTERVAL 2 DAY, 55),
(19, CURDATE() - INTERVAL 3 DAY, 61),
(19, CURDATE() - INTERVAL 4 DAY, 23),
(19, CURDATE() - INTERVAL 5 DAY, 34),
(19, CURDATE() - INTERVAL 6 DAY, 37),
(20, CURDATE() - INTERVAL 0 DAY, 40),
(20, CURDATE() - INTERVAL 1 DAY, 28),
(20, CURDATE() - INTERVAL 2 DAY, 38),
(20, CURDATE() - INTERVAL 3 DAY, 31),
(20, CURDATE() - INTERVAL 4 DAY, 24),
(20, CURDATE() - INTERVAL 5 DAY, 36),
(20, CURDATE() - INTERVAL 6 DAY, 13);

INSERT INTO reviews (book_id, user_id, rating, comment, created_at) VALUES
(1, 2, 5, 'Every chapter ends on a hook. Highly recommend.', NOW() - INTERVAL 9 DAY),
(1, 4, 5, 'One of the best on the site. The world-building is fantastic.', NOW() - INTERVAL 5 DAY),
(2, 4, 5, 'One of the best on the site. The world-building is fantastic.', NOW() - INTERVAL 7 DAY),
(3, 2, 4, 'Great characters, looking forward to more updates.', NOW() - INTERVAL 24 DAY),
(3, 3, 5, 'Every chapter ends on a hook. Highly recommend.', NOW() - INTERVAL 13 DAY),
(4, 2, 4, 'Solid story with a satisfying pace.', NOW() - INTERVAL 4 DAY),
(4, 4, 5, 'Every chapter ends on a hook. Highly recommend.', NOW() - INTERVAL 37 DAY),
(5, 3, 5, 'Absolutely loved it, could not stop reading.', NOW() - INTERVAL 7 DAY),
(6, 2, 5, 'One of the best on the site. The world-building is fantastic.', NOW() - INTERVAL 10 DAY),
(6, 4, 4, 'Solid story with a satisfying pace.', NOW() - INTERVAL 7 DAY),
(7, 2, 5, 'Every chapter ends on a hook. Highly recommend.', NOW() - INTERVAL 7 DAY),
(8, 4, 4, 'Really enjoyable, a few slow chapters but worth it.', NOW() - INTERVAL 15 DAY),
(9, 2, 5, 'One of the best on the site. The world-building is fantastic.', NOW() - INTERVAL 23 DAY),
(9, 4, 4, 'Solid story with a satisfying pace.', NOW() - INTERVAL 34 DAY),
(10, 2, 5, 'Every chapter ends on a hook. Highly recommend.', NOW() - INTERVAL 26 DAY),
(11, 3, 2, 'Not really for me, but the premise is interesting.', NOW() - INTERVAL 6 DAY),
(12, 2, 4, 'Solid story with a satisfying pace.', NOW() - INTERVAL 15 DAY),
(12, 4, 5, 'Absolutely loved it, could not stop reading.', NOW() - INTERVAL 5 DAY),
(13, 2, 4, 'Solid story with a satisfying pace.', NOW() - INTERVAL 4 DAY),
(15, 2, 5, 'One of the best on the site. The world-building is fantastic.', NOW() - INTERVAL 3 DAY),
(16, 2, 5, 'One of the best on the site. The world-building is fantastic.', NOW() - INTERVAL 36 DAY),
(16, 4, 4, 'Solid story with a satisfying pace.', NOW() - INTERVAL 1 DAY),
(17, 2, 3, 'Good idea, the execution is a bit uneven.', NOW() - INTERVAL 26 DAY),
(17, 3, 5, 'One of the best on the site. The world-building is fantastic.', NOW() - INTERVAL 6 DAY),
(18, 3, 4, 'Great characters, looking forward to more updates.', NOW() - INTERVAL 27 DAY),
(20, 2, 4, 'Great characters, looking forward to more updates.', NOW() - INTERVAL 33 DAY),
(20, 4, 2, 'Not really for me, but the premise is interesting.', NOW() - INTERVAL 28 DAY);

INSERT INTO reading_list (user_id, book_id, in_library, last_chapter, updated_at) VALUES
(2, 1, 1, 4, NOW() - INTERVAL 2 HOUR),
(2, 3, 1, 3, NOW() - INTERVAL 1 DAY),
(2, 7, 1, 0, NOW() - INTERVAL 3 DAY),
(2, 10, 0, 2, NOW() - INTERVAL 5 DAY),
(3, 1, 1, 2, NOW() - INTERVAL 6 HOUR);

INSERT INTO orders (user_id, total, status, created_at) VALUES
(2, 8.98, 'success', NOW() - INTERVAL 6 DAY),
(3, 4.49, 'failed',  NOW() - INTERVAL 4 DAY),
(3, 4.49, 'success', NOW() - INTERVAL 4 DAY),
(4, 4.99, 'success', NOW() - INTERVAL 1 DAY);

INSERT INTO order_items (order_id, book_id, price) VALUES
(1, 1, 4.99), (1, 3, 3.99),
(2, 4, 4.49),
(3, 4, 4.49),
(4, 6, 4.99);

INSERT INTO cart_items (user_id, book_id) VALUES (2, 5);
