-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Creato il: Mag 22, 2021 alle 16:13
-- Versione del server: 10.4.14-MariaDB
-- Versione PHP: 7.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `palestra_sito`
--

DELIMITER $$
--
-- Procedure
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `cerca_abbonamenti` (IN `CF_cliente` VARCHAR(16))  begin
drop table if exists abb_validi;
create temporary table abb_validi(CF varchar(16), nome varchar(30), cognome varchar(30), corso varchar(30), tipo varchar(20),
data_inizio date, quota float, scadenza date);
insert into abb_validi
select i.CF_cl, i.nome_cl, i.cognome_cl, i.corso_abb, i.tipo_abb, i.data_inizio_abb, i.quota_abb, i.scadenza_abb
from info_cliente_abb i
where i.CF_cl = CF_cliente and i.scadenza_abb >= current_date;

drop table if exists abb_scaduti;
create temporary table abb_scaduti(CF varchar(16), nome varchar(30), cognome varchar(30), corso varchar(30), tipo varchar(20),
data_inizio date, quota float, scadenza date);
insert into abb_scaduti
select i.CF_cl, i.nome_cl, i.cognome_cl, i.corso_abb, i.tipo_abb, i.data_inizio_abb, i.quota_abb, i.scadenza_abb
from info_cliente_abb i
where i.CF_cl = CF_cliente and i.scadenza_abb < current_date;

end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eta_stip_medio_dip` (OUT `media_età` FLOAT, OUT `media_stip` FLOAT)  begin
select avg (d.età), avg (d.stipendio_mensile) into media_età, media_stip
       from dipendente d;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `inserisci_cliente` (OUT `ID_cl` INT, IN `CF_cl` VARCHAR(16), IN `nome_cl` VARCHAR(30), IN `cognome_cl` VARCHAR(30), IN `data_nascita_cl` DATE, IN `età_cl` INT, IN `corso_abb` VARCHAR(30), IN `tipo_abb` VARCHAR(20), IN `data_inizio_abb` DATE, OUT `quota_abb` FLOAT, OUT `scadenza_abb` DATE)  begin
insert into cliente(cf, nome, cognome, data_di_nascita, età)
            values (CF_cl, nome_cl, cognome_cl, data_nascita_cl, età_cl);

select c.ID into ID_cl from cliente c where C.CF=CF_cl;

CASE tipo_abb
        when 'MENSILE' then SET quota_abb=40;
        when 'TRIMESTRALE' then SET quota_abb=105;
        when 'SEMESTRALE' then SET quota_abb=180;
        when 'ANNUALE' then SET quota_abb=300;
    END CASE;

CASE tipo_abb
        when 'MENSILE' then SET scadenza_abb=date_add(data_inizio_abb, interval 1 month);
        when 'TRIMESTRALE' then SET scadenza_abb=date_add(data_inizio_abb, interval 3 month);
        when 'SEMESTRALE' then SET scadenza_abb=date_add(data_inizio_abb, interval 6 month);
        when 'ANNUALE' then SET scadenza_abb=date_add(data_inizio_abb, interval 1 year);
    END CASE;

insert into abbonamento (cliente, corso, tipo, data_inizio, quota, scadenza)
                 values (ID_cl, corso_abb, tipo_abb, data_inizio_abb, quota_abb, scadenza_abb);

end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `istrutt_corsi` ()  begin
drop table if exists istrutt_attuali;
create temporary table istrutt_attuali(corso varchar(30), num_istruttori integer);
insert into istrutt_attuali
select i.corso, count(i.istruttore) as num_istruttori from insegnamento i group by i.corso;

drop table if exists istrutt_passati;
create temporary table istrutt_passati(corso varchar(30), num_istruttori integer);
insert into istrutt_passati
select i.corso, count(i.istruttore) as num_istruttori from insegnamento_passato i group by i.corso;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `stampa_scheda` (IN `CF_cliente` VARCHAR(16), IN `data_rich` DATE)  begin
drop table if exists info_scheda;
create temporary table info_scheda(codice integer, nome_istr varchar(30), cognome_istr varchar(30), data_richiesta date,
obiettivo varchar(50), durata varchar(30));
insert into info_scheda
select s.COD, d.nome, d.cognome, s.data, s.obiettivo, s.durata
from scheda s join dipendente d on s.istruttore=d.ID
where s.COD in (select i.SCHEDA from info_richiesta i where i.CF_cl=CF_cliente and i.DATA = data_rich);

drop table if exists info_composizione;
create temporary table info_composizione(esercizio varchar(50), peso_kg float, serie integer, ripetizioni integer);
insert into info_composizione
select c.esercizio, c.peso, c.serie, c.ripetizioni
from composizione c
where c.scheda in (select info_s.codice from info_scheda info_s);
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `abbonamento`
--

CREATE TABLE `abbonamento` (
  `COD` int(11) NOT NULL,
  `cliente` int(11) NOT NULL,
  `corso` varchar(30) NOT NULL,
  `tipo` varchar(20) DEFAULT NULL,
  `data_inizio` date DEFAULT NULL,
  `quota` float DEFAULT NULL,
  `scadenza` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `abbonamento`
--

INSERT INTO `abbonamento` (`COD`, `cliente`, `corso`, `tipo`, `data_inizio`, `quota`, `scadenza`) VALUES
(1, 1, 'ZUMBA', 'SEMESTRALE', '2020-10-20', 180, '2021-04-20'),
(2, 2, 'SALA PESI', 'MENSILE', '2020-12-15', 40, '2021-01-15'),
(3, 3, 'INDOOR CYCLING', 'TRIMESTRALE', '2020-09-07', 105, '2020-12-07'),
(4, 4, 'SALA PESI', 'TRIMESTRALE', '2020-11-05', 105, '2021-02-05'),
(5, 5, 'GINNASTICA CORRETTIVA', 'ANNUALE', '2020-01-17', 300, '2021-01-17'),
(6, 6, 'KARATE', 'MENSILE', '2020-09-02', 40, '2020-10-02'),
(7, 7, 'KARATE', 'TRIMESTRALE', '2020-10-19', 105, '2021-01-19'),
(8, 8, 'INDOOR CYCLING', 'SEMESTRALE', '2020-09-05', 180, '2021-03-05'),
(9, 9, 'SALA PESI', 'TRIMESTRALE', '2020-12-02', 105, '2021-03-02'),
(10, 10, 'SALA PESI', 'ANNUALE', '2020-09-09', 300, '2021-09-09'),
(11, 11, 'FUNCTIONAL TRAINING', 'TRIMESTRALE', '2020-09-03', 105, '2020-12-03'),
(12, 12, 'FUNCTIONAL TRAINING', 'SEMESTRALE', '2020-09-07', 180, '2021-03-07'),
(13, 2, 'FUNCTIONAL TRAINING', 'TRIMESTRALE', '2020-11-03', 105, '2021-02-03'),
(14, 6, 'FUNCTIONAL TRAINING', 'SEMESTRALE', '2020-10-05', 180, '2021-04-05'),
(15, 13, 'KARATE', 'ANNUALE', '2020-10-05', 300, '2021-10-05'),
(16, 14, 'ZUMBA', 'TRIMESTRALE', '2020-11-03', 105, '2021-02-03'),
(17, 15, 'GINNASTICA CORRETTIVA', 'ANNUALE', '2020-09-05', 300, '2021-09-05'),
(18, 16, 'ZUMBA', 'MENSILE', '2020-12-05', 40, '2021-01-05'),
(19, 17, 'GINNASTICA CORRETTIVA', 'SEMESTRALE', '2020-09-05', 180, '2021-03-05'),
(24, 19, 'ZUMBA', 'TRIMESTRALE', '2021-05-12', 105, '2021-08-12'),
(34, 50, 'ZUMBA', 'MENSILE', '2021-05-14', 40, '2021-06-14'),
(35, 1, 'GINNASTICA CORRETTIVA', 'MENSILE', '2021-05-21', 40, '2021-06-21'),
(36, 54, 'INDOOR CYCLING', 'TRIMESTRALE', '2021-05-21', 105, '2021-08-21'),
(37, 54, 'KARATE', 'SEMESTRALE', '2021-05-21', 180, '2021-11-21'),
(38, 4, 'INDOOR CYCLING', 'ANNUALE', '2021-05-21', 300, '2022-05-21'),
(40, 8, 'KARATE', 'MENSILE', '2021-05-21', 40, '2021-06-21'),
(41, 57, 'INDOOR CYCLING', 'MENSILE', '2021-05-21', 40, '2021-06-21'),
(42, 57, 'FUNCTIONAL TRAINING', 'SEMESTRALE', '2021-05-21', 180, '2021-11-21');

--
-- Trigger `abbonamento`
--
DELIMITER $$
CREATE TRIGGER `allinea_num_iscritti` BEFORE INSERT ON `abbonamento` FOR EACH ROW begin
    CASE NEW.corso
            WHEN 'FUNCTIONAL TRAINING' THEN update corso set num_iscritti=num_iscritti+1 where corso.nome = 'FUNCTIONAL TRAINING';
            WHEN 'GINNASTICA CORRETTIVA' THEN update corso set num_iscritti=num_iscritti+1 where corso.nome = 'GINNASTICA CORRETTIVA';
            WHEN 'INDOOR CYCLING' THEN update corso set num_iscritti=num_iscritti+1 where corso.nome = 'INDOOR CYCLING';
            WHEN 'KARATE' THEN update corso set num_iscritti=num_iscritti+1 where corso.nome = 'KARATE';
            WHEN 'SALA PESI' THEN update corso set num_iscritti=num_iscritti+1 where corso.nome = 'SALA PESI';
            WHEN 'ZUMBA' THEN update corso set num_iscritti=num_iscritti+1 where corso.nome = 'ZUMBA';
END CASE;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `blocco_homepage`
--

CREATE TABLE `blocco_homepage` (
  `ID` int(11) NOT NULL,
  `title` varchar(20) DEFAULT NULL,
  `image_src` varchar(50) DEFAULT NULL,
  `description` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `blocco_homepage`
--

INSERT INTO `blocco_homepage` (`ID`, `title`, `image_src`, `description`) VALUES
(1, 'Corsi', 'CORSI.jpg', 'La nostra ampia offerta di corsi'),
(2, 'Sala Pesi', 'SALA PESI.jpg', 'Gli esercizi che è possibile fare in Sala Pesi'),
(3, 'Orari', 'ORARI.png', 'La tabella completa con gli orari dei corsi'),
(4, 'Stage', 'STAGE.jpeg', 'Gli Stage organizzati per i nostri clienti'),
(5, 'Staff', 'STAFF.jpg', 'Il dirigente, il personale di segreteria e gli istruttori'),
(6, 'Gallery', 'GALLERY.jpg', 'Una carrellata dei momenti vissuti alla Power Fitness Gym');

-- --------------------------------------------------------

--
-- Struttura della tabella `cliente`
--

CREATE TABLE `cliente` (
  `ID` int(11) NOT NULL,
  `CF` varchar(16) DEFAULT NULL,
  `nome` varchar(30) DEFAULT NULL,
  `cognome` varchar(30) DEFAULT NULL,
  `data_di_nascita` date DEFAULT NULL,
  `età` int(11) DEFAULT NULL,
  `username` varchar(20) NOT NULL,
  `email` varchar(50) DEFAULT NULL,
  `password` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `cliente`
--

INSERT INTO `cliente` (`ID`, `CF`, `nome`, `cognome`, `data_di_nascita`, `età`, `username`, `email`, `password`) VALUES
(1, 'BNIRKE10H62H501Z', 'Erika', 'Bini', '2000-06-22', 20, 'Erika2000', 'erikabini@gmail.com', 'Bini2000!'),
(2, 'GTTMRS04M48C351Q', 'Mariarosa', 'Gatto', '1981-08-08', 39, 'Mariarosa81', 'mariarosagatto@outlook.it', 'Gatto81!'),
(3, 'PLLVTR08A23L219X', 'Vittorio', 'Pellegrino', '1970-01-23', 50, 'Vittorio70', 'vittoriopellegrino@libero.it', 'Pellegrino70!'),
(4, 'MRADLN05B24D969U', 'Dylan', 'Mare', '1992-02-24', 28, 'Dylan92', 'dylanmare@gmail.com', 'Mare92!'),
(5, 'SPNNCL04R09C351U', 'Nicolò', 'Spinelli', '2005-10-09', 15, 'Nicolò05', 'nicolòspinelli@outlook.it', 'Spinelli05!'),
(6, 'PZZPLT05R16D612N', 'Ippolito', 'Pizzi', '1975-10-16', 45, 'Ippolito75', 'ippolitopizzi@libero.it', 'Pizzi75!'),
(7, 'SCHRNN03L55F839Z', 'Rosanna', 'Schiavo', '1987-07-15', 33, 'Rosanna87', 'rosannaschiavo@outlook.it', 'Schiavo87!'),
(8, 'STFPNG06A15F839Z', 'Pierangelo', 'Stefanelli', '1973-01-15', 47, 'Pierangelo73', 'pierangelostefanelli@libero.it', 'Stefanelli73!'),
(9, 'RGSLSS10P55C351Y', 'Alessia', 'Ragusa', '2004-09-15', 16, 'Alessia04', 'alessiaragusa@gmail.com', 'Ragusa04!'),
(10, 'SLVGPP08E07F839K', 'Giuseppe', 'Salvatori', '2002-05-07', 18, 'Giuseppe02', 'giuseppesalvatori@gmail.com', 'Salvatori02!'),
(11, 'MLNVNT04R14D612A', 'Valentino', 'Meloni', '1990-10-14', 30, 'Valentino90', 'valentinomeloni@libero.it', 'Meloni90!'),
(12, 'CRTLDE03L54F839Y', 'Elide', 'Cortese', '2000-07-14', 20, 'Elide2000', 'elidecortese@outlook.it', 'Cortese2000!'),
(13, 'GGLDNC06D19G273H', 'Domenico', 'Gagliardo', '1979-04-19', 41, 'Domenico79', 'domenicogagliardo@libero.it', 'Gagliardo79!'),
(14, 'GRNRSL08S57A944N', 'Rosalia', 'Grandi', '2003-11-17', 17, 'Rosalia03', 'rosaliagrandi@gmail.com', 'Grandi03!'),
(15, 'SCHNNN02C21H501D', 'Antonino', 'Schiavo', '2006-03-21', 14, 'Antonino06', 'antoninoschiavo@libero.it', 'Schiavo06!'),
(16, 'DMRVLI04B63D969Z', 'Viola', 'Dimarco', '1990-02-23', 30, 'Viola90', 'violadimarco@outlook.it', 'Dimarco90!'),
(17, 'LTTCRL09A45F205F', 'Carla', 'Lotti', '2005-01-05', 15, 'Carla05', 'carlalotti@gmail.com', 'Lotti05!'),
(19, 'RGHGTA10L58A944J', 'Agata', 'Righi', '1987-07-18', 34, 'Agata87', 'agatarighi87@outlook.it', 'Righi87!'),
(50, 'VTLCRS05A50F205T', 'Clarissa', 'Vitale', '1995-01-10', 26, 'Clarissa95', 'clarissavitale95@outlook.it', 'Vitale95!'),
(54, 'CSTTRS08H64C351H', 'Teresa', 'Castellani', '1998-06-24', 23, 'Teresa98', 'teresacastellani98@outlook.it', 'Castellani98!'),
(57, 'MRAFNC07L65F839M', 'Franca', 'Mari', '1997-07-25', 24, 'Franca97', 'francamari@outlook.it', 'Mari97!!');

-- --------------------------------------------------------

--
-- Struttura della tabella `composizione`
--

CREATE TABLE `composizione` (
  `scheda` int(11) NOT NULL,
  `cliente` int(11) NOT NULL,
  `istruttore` int(11) NOT NULL,
  `esercizio` varchar(50) NOT NULL,
  `peso` float DEFAULT NULL,
  `serie` int(11) DEFAULT NULL,
  `ripetizioni` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `composizione`
--

INSERT INTO `composizione` (`scheda`, `cliente`, `istruttore`, `esercizio`, `peso`, `serie`, `ripetizioni`) VALUES
(1, 2, 3, 'AFFONDI CON MANUBRI', 6, 3, 12),
(1, 2, 3, 'CRUNCH', NULL, 4, 10),
(1, 2, 3, 'LAT MACHINE PRESA SUPINA', 10, 4, 10),
(1, 2, 3, 'LEG PRESS', 10, 4, 10),
(1, 2, 3, 'PANCA INCLINATA MANUBRI', 4, 3, 12),
(1, 2, 3, 'PLANK', NULL, 1, 20),
(2, 4, 11, 'ALZATE LATERALI', 4, 3, 12),
(2, 4, 11, 'CROCI SU PANCA PIANA CON MANUBRI', 5, 3, 12),
(2, 4, 11, 'CRUNCH', NULL, 4, 10),
(2, 4, 11, 'LAT MACHINE PRESA PRONA', 15, 3, 12),
(2, 4, 11, 'LEG PRESS', 10, 4, 10),
(2, 4, 11, 'PANCA PIANA MANUBRI', 6, 4, 10),
(2, 4, 11, 'PLANK', NULL, 1, 20),
(2, 4, 11, 'PULLEY', 10, 3, 12),
(3, 4, 3, 'ALZATE FRONTALI', 8, 3, 12),
(3, 4, 3, 'CROCI SU PANCA PIANA CON MANUBRI', 10, 3, 12),
(3, 4, 3, 'CRUNCH', NULL, 4, 10),
(3, 4, 3, 'LAT MACHINE PRESA PRONA', 30, 3, 12),
(3, 4, 3, 'PANCA INCLINATA MANUBRI', 10, 3, 12),
(3, 4, 3, 'PANCA PIANA MANUBRI', 15, 4, 10),
(3, 4, 3, 'PLANK', NULL, 1, 20),
(3, 4, 3, 'REMATORE MANUBRI', 10, 3, 12),
(4, 9, 9, 'AFFONDI CON MANUBRI', 6, 3, 12),
(4, 9, 9, 'CRUNCH', NULL, 4, 10),
(4, 9, 9, 'LAT MACHINE PRESA PRONA', 10, 4, 10),
(4, 9, 9, 'LEG PRESS', 10, 4, 10),
(4, 9, 9, 'PANCA INCLINATA MANUBRI', 4, 3, 12),
(4, 9, 9, 'PLANK', NULL, 1, 20),
(5, 9, 9, 'BACK SQUAT CON BILANCIERE', 30, 4, 10),
(5, 9, 9, 'LAT MACHINE PRESA SUPINA', 10, 4, 10),
(5, 9, 9, 'LEG EXTENSION', 10, 3, 12),
(5, 9, 9, 'LEG RAISE', NULL, 4, 10),
(5, 9, 9, 'PANCA PIANA MANUBRI', 4, 3, 12),
(5, 9, 9, 'PLANK', NULL, 1, 20),
(6, 10, 3, 'ALZATE LATERALI', 3, 3, 12),
(6, 10, 3, 'CROCI SU PANCA PIANA CON MANUBRI', 3, 3, 12),
(6, 10, 3, 'CURL A MARTELLO', 3, 3, 12),
(6, 10, 3, 'LAT MACHINE PRESA PRONA', 15, 4, 10),
(6, 10, 3, 'LEG PRESS', 10, 4, 10),
(6, 10, 3, 'LEG RAISE', NULL, 4, 10),
(6, 10, 3, 'PANCA PIANA MANUBRI', 4, 4, 10),
(6, 10, 3, 'PLANK', NULL, 1, 20),
(6, 10, 3, 'PULLEY', 10, 3, 12),
(6, 10, 3, 'PUSH DOWN', 10, 3, 12),
(7, 10, 9, 'ALZATE FRONTALI', 6, 3, 12),
(7, 10, 9, 'BACK SQUAT CON BILANCIERE', 30, 4, 10),
(7, 10, 9, 'CROCI AI CAVI', 15, 3, 12),
(7, 10, 9, 'CRUNCH', NULL, 4, 10),
(7, 10, 9, 'CURL A MARTELLO', 6, 3, 12),
(7, 10, 9, 'LAT MACHINE PRESA PRONA', 30, 4, 10),
(7, 10, 9, 'LEG RAISE', NULL, 4, 10),
(7, 10, 9, 'PANCA INCLINATA MANUBRI', 8, 3, 12),
(7, 10, 9, 'PANCA PIANA MANUBRI', 10, 4, 10),
(7, 10, 9, 'PLANK', NULL, 1, 20),
(7, 10, 9, 'PULLEY', 20, 3, 12),
(7, 10, 9, 'PUSH DOWN', 25, 3, 12),
(8, 10, 9, 'ALZATE FRONTALI', 10, 3, 12),
(8, 10, 9, 'BACK SQUAT CON BILANCIERE', 30, 4, 10),
(8, 10, 9, 'CROCI AI CAVI', 25, 3, 12),
(8, 10, 9, 'CRUNCH', NULL, 4, 10),
(8, 10, 9, 'CURL MANUBRI', 10, 3, 12),
(8, 10, 9, 'FRENCH PRESS CON MANUBRI', 15, 3, 12),
(8, 10, 9, 'LEG EXTENSION', 30, 3, 12),
(8, 10, 9, 'LEG RAISE', NULL, 4, 10),
(8, 10, 9, 'PANCA INCLINATA MANUBRI', 15, 3, 12),
(8, 10, 9, 'PANCA PIANA BILANCIERE', 50, 4, 10),
(8, 10, 9, 'PLANK', NULL, 1, 20),
(8, 10, 9, 'REMATORE MANUBRI', 20, 3, 12),
(8, 10, 9, 'TRAZIONI ALLA SBARRA PRESA SUPINA', NULL, 4, 10),
(9, 10, 11, 'ALZATE LATERALI', 30, 3, 12),
(9, 10, 11, 'BACK SQUAT CON BILANCIERE', 60, 4, 10),
(9, 10, 11, 'CROCI AI CAVI', 35, 3, 12),
(9, 10, 11, 'CRUNCH', NULL, 4, 10),
(9, 10, 11, 'CURL MANUBRI', 10, 3, 12),
(9, 10, 11, 'FRENCH PRESS CON MANUBRI', 30, 3, 12),
(9, 10, 11, 'LEG EXTENSION', 50, 3, 12),
(9, 10, 11, 'LEG RAISE', NULL, 4, 10),
(9, 10, 11, 'MILITARY PRESS', 40, 4, 10),
(9, 10, 11, 'PANCA INCLINATA MANUBRI', 30, 3, 12),
(9, 10, 11, 'PANCA PIANA BILANCIERE', 80, 4, 10),
(9, 10, 11, 'PLANK', NULL, 1, 20),
(9, 10, 11, 'REMATORE MANUBRI', 40, 3, 12),
(9, 10, 11, 'TRAZIONI ALLA SBARRA PRESA PRONA', NULL, 4, 10);

-- --------------------------------------------------------

--
-- Struttura della tabella `corso`
--

CREATE TABLE `corso` (
  `nome` varchar(30) NOT NULL,
  `num_iscritti` int(11) DEFAULT NULL,
  `image_url` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `corso`
--

INSERT INTO `corso` (`nome`, `num_iscritti`, `image_url`) VALUES
('FUNCTIONAL TRAINING', 6, 'FUNCTIONAL_TRAINING.jpg'),
('GINNASTICA CORRETTIVA', 4, 'GINNASTICA_CORRETTIVA.jpg'),
('INDOOR CYCLING', 5, 'INDOOR_CYCLING2.jpg'),
('KARATE', 6, 'KARATE2.jpg'),
('SALA PESI', 7, 'SALA_PESI2.jpg'),
('ZUMBA', 11, 'ZUMBA2.jpg');

-- --------------------------------------------------------

--
-- Struttura della tabella `dipendente`
--

CREATE TABLE `dipendente` (
  `ID` int(11) NOT NULL,
  `CF` varchar(16) DEFAULT NULL,
  `nome` varchar(30) DEFAULT NULL,
  `cognome` varchar(30) DEFAULT NULL,
  `data_di_nascita` date DEFAULT NULL,
  `età` int(11) DEFAULT NULL,
  `stipendio_mensile` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `dipendente`
--

INSERT INTO `dipendente` (`ID`, `CF`, `nome`, `cognome`, `data_di_nascita`, `età`, `stipendio_mensile`) VALUES
(1, 'ZNTLNE04C50A662X', 'Eliana', 'Zanotti', '1980-03-10', 40, 800),
(2, 'LLLFLL09T56H501Z', 'Fiorella', 'Lelli', '1970-12-16', 50, 850),
(3, 'BRBMCL07E18C351S', 'Marcello', 'Barbieri', '1990-05-18', 30, 1000),
(4, 'SLALLL06M46C351E', 'Lorella', 'Sala', '1985-08-06', 35, 950),
(5, 'CRAGRG07L20D969F', 'Giorgio', 'Cara', '1978-07-20', 42, 900),
(6, 'FLPBDT05L26F205A', 'Benedetto', 'Filippini', '1961-07-26', 51, 1000),
(7, 'LCCMRT08C15F839W', 'Umberto', 'Lucci', '1977-03-15', 43, 950),
(8, 'BSSLLL03D42H501S', 'Lorella', 'Bossi', '1993-04-02', 27, 800),
(9, 'LLLGLG03T30F205C', 'Gianluigi', 'Lelli', '1987-12-30', 33, 900),
(10, 'BNTLCN03R09A944T', 'Luciano', 'Benetti', '1973-10-09', 47, 800),
(11, 'CSTCST04R19A662B', 'Cristian', 'Costantini', '1980-10-19', 40, 950),
(12, 'GIODTL08A29L219D', 'Donatello', 'Gioia', '1980-01-29', 40, 950),
(13, 'PGNTTN05S54F839Z', 'Tatiana', 'Pagani', '1983-11-14', 37, 850),
(14, 'CSTSVR03B11L736D', 'Saverio', 'Costantini', '1985-02-11', 35, 800),
(15, 'MNTMNL06D55F205N', 'Manuela', 'Mantovani', '1980-04-15', 40, 1000);

-- --------------------------------------------------------

--
-- Struttura della tabella `direttore`
--

CREATE TABLE `direttore` (
  `ID` int(11) NOT NULL,
  `CF` varchar(16) DEFAULT NULL,
  `nome` varchar(30) DEFAULT NULL,
  `cognome` varchar(30) DEFAULT NULL,
  `data_di_nascita` date DEFAULT NULL,
  `età` int(11) DEFAULT NULL,
  `vice` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `direttore`
--

INSERT INTO `direttore` (`ID`, `CF`, `nome`, `cognome`, `data_di_nascita`, `età`, `vice`) VALUES
(1, 'LPUGLN02D14L736U', 'Giuliano', 'Lupi', '1964-04-14', 56, NULL);

-- --------------------------------------------------------

--
-- Struttura della tabella `esercizio`
--

CREATE TABLE `esercizio` (
  `nome` varchar(50) NOT NULL,
  `target` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `esercizio`
--

INSERT INTO `esercizio` (`nome`, `target`) VALUES
('AFFONDI CON MANUBRI', 'Quadricipiti, Glutei, Femorali'),
('ALZATE FRONTALI', 'Deltoidi'),
('ALZATE LATERALI', 'Deltoidi'),
('BACK SQUAT CON BILANCIERE', 'Quadricipiti, Glutei, Femorali'),
('CROCI AI CAVI', 'Pettorali'),
('CROCI SU PANCA INCLINATA CON MANUBRI', 'Pettorali'),
('CROCI SU PANCA PIANA CON MANUBRI', 'Pettorali'),
('CRUNCH', 'Addominali'),
('CURL A MARTELLO', 'Bicipiti'),
('CURL MANUBRI', 'Bicipiti'),
('FRENCH PRESS CON MANUBRI', 'Tricipiti'),
('LAT MACHINE PRESA PRONA', 'Dorsali'),
('LAT MACHINE PRESA SUPINA', 'Dorsali, Bicipiti'),
('LEG CURL', 'Femorali'),
('LEG EXTENSION', 'Quadricipiti'),
('LEG PRESS', 'Quadricipiti, Glutei'),
('LEG RAISE', 'Addominali'),
('MILITARY PRESS', 'Deltoidi'),
('PANCA INCLINATA BILANCIERE', 'Pettorali Alti, Tricipiti, Deltoidi Anteriori'),
('PANCA INCLINATA MANUBRI', 'Pettorali Alti, Tricipiti, Deltoidi Anteriori'),
('PANCA PIANA BILANCIERE', 'Pettorali, Tricipiti, Deltoidi Anteriori'),
('PANCA PIANA MANUBRI', 'Pettorali, Tricipiti, Deltoidi Anteriori'),
('PIEGAMENTI A DIAMANTE', 'Tricipiti, Pettorali, Deltoidi Anteriori'),
('PIEGAMENTI SULLE BRACCIA', 'Pettorali, Tricipiti, Deltoidi Anteriori'),
('PLANK', 'Addominali'),
('PULLEY', 'dorsali'),
('PUSH DOWN', 'Tricipiti'),
('REMATORE MANUBRI', 'Dorsali'),
('SQUAT CON MANUBRI', 'Quadricipiti, Glutei, Femorali'),
('TRAZIONI ALLA SBARRA PRESA PRONA', 'Dorsali'),
('TRAZIONI ALLA SBARRA PRESA SUPINA', 'Dorsali, Bicipiti');

-- --------------------------------------------------------

--
-- Struttura stand-in per le viste `info_cliente_abb`
-- (Vedi sotto per la vista effettiva)
--
CREATE TABLE `info_cliente_abb` (
`id_cl` int(11)
,`CF_cl` varchar(16)
,`nome_cl` varchar(30)
,`cognome_cl` varchar(30)
,`cod_abb` int(11)
,`corso_abb` varchar(30)
,`tipo_abb` varchar(20)
,`data_inizio_abb` date
,`quota_abb` float
,`scadenza_abb` date
);

-- --------------------------------------------------------

--
-- Struttura stand-in per le viste `info_richiesta`
-- (Vedi sotto per la vista effettiva)
--
CREATE TABLE `info_richiesta` (
`id_cl` int(11)
,`CF_cl` varchar(16)
,`nome_cl` varchar(30)
,`cognome_cl` varchar(30)
,`SCHEDA` int(11)
,`DATA` date
,`id_istr` int(11)
,`CF_istr` varchar(16)
,`nome_istr` varchar(30)
,`cognome_istr` varchar(30)
);

-- --------------------------------------------------------

--
-- Struttura della tabella `insegnamento`
--

CREATE TABLE `insegnamento` (
  `istruttore` int(11) NOT NULL,
  `corso` varchar(30) NOT NULL,
  `data_inzio` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `insegnamento`
--

INSERT INTO `insegnamento` (`istruttore`, `corso`, `data_inzio`) VALUES
(3, 'FUNCTIONAL TRAINING', '2019-09-05'),
(3, 'SALA PESI', '2017-09-02'),
(4, 'ZUMBA', '2020-09-05'),
(6, 'KARATE', '2012-09-04'),
(7, 'GINNASTICA CORRETTIVA', '2016-09-07'),
(7, 'ZUMBA', '2020-12-05'),
(8, 'FUNCTIONAL TRAINING', '2017-09-07'),
(9, 'SALA PESI', '2019-09-04'),
(10, 'INDOOR CYCLING', '2018-09-04'),
(11, 'SALA PESI', '2010-01-12'),
(12, 'KARATE', '2020-12-11'),
(13, 'ZUMBA', '2020-12-11'),
(14, 'INDOOR CYCLING', '2020-12-11'),
(15, 'GINNASTICA CORRETTIVA', '2020-12-11');

--
-- Trigger `insegnamento`
--
DELIMITER $$
CREATE TRIGGER `verifica_formazione` BEFORE INSERT ON `insegnamento` FOR EACH ROW begin
SET @formazione = null;
select istr.formazione into @formazione from istruttore istr where istr.ID = NEW.istruttore;
if (@formazione = 'CERTIFICAZIONE FIF' and (NEW.corso = 'GINNASTICA CORRETTIVA' or NEW.corso = 'ZUMBA' or NEW.corso = 'KARATE'))
    then signal sqlstate '45000' set message_text = 'Istruttore NON ha la formazione adeguata per insegnare questo corso!';
end if;

if (@formazione = 'CERTIFICAZIONE CONI' and NEW.corso <> 'KARATE')
         then signal sqlstate '45000' set message_text = 'Istruttore NON ha la formazione adeguata per insegnare questo corso!';
end if;

if (@formazione = 'CERTIFICAZIONE ZUMBA ACADEMY' and NEW.corso <> 'ZUMBA')
then signal sqlstate '45000' set message_text = 'Istruttore NON ha la formazione adeguata per insegnare questo corso!';
end if;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `insegnamento_passato`
--

CREATE TABLE `insegnamento_passato` (
  `istruttore` int(11) NOT NULL,
  `corso` varchar(30) NOT NULL,
  `data_inzio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `insegnamento_passato`
--

INSERT INTO `insegnamento_passato` (`istruttore`, `corso`, `data_inzio`, `data_fine`) VALUES
(7, 'SALA PESI', '2010-09-06', '2016-09-06'),
(10, 'FUNCTIONAL TRAINING', '2014-09-03', '2018-09-03'),
(11, 'INDOOR CYCLING', '2008-01-11', '2010-01-11');

-- --------------------------------------------------------

--
-- Struttura della tabella `istruttore`
--

CREATE TABLE `istruttore` (
  `ID` int(11) NOT NULL,
  `formazione` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `istruttore`
--

INSERT INTO `istruttore` (`ID`, `formazione`) VALUES
(3, 'CERTIFICAZIONE FIF'),
(4, 'CERTIFICAZIONE ZUMBA ACADEMY'),
(6, 'CERTIFICAZIONE CONI'),
(7, 'LAUREA IN SCIENZE MOTORIE'),
(8, 'CERTIFICAZIONE FIF'),
(9, 'CERTIFICAZIONE FIF'),
(10, 'CERTIFICAZIONE FIF'),
(11, 'CERTIFICAZIONE FIF'),
(12, 'CERTIFICAZIONE CONI'),
(13, 'CERTIFICAZIONE ZUMBA ACADEMY'),
(14, 'CERTIFICAZIONE FIF'),
(15, 'LAUREA IN SCIENZE MOTORIE');

-- --------------------------------------------------------

--
-- Struttura della tabella `partecipa`
--

CREATE TABLE `partecipa` (
  `cliente` int(11) NOT NULL,
  `stage` varchar(30) NOT NULL,
  `data` date NOT NULL,
  `istruttore_esterno` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `partecipa`
--

INSERT INTO `partecipa` (`cliente`, `stage`, `data`, `istruttore_esterno`) VALUES
(7, 'KARATE', '2020-12-02', 'Edoardo Delfino'),
(12, 'FUNCTIONAL TRAINING', '2020-09-22', 'Felicia Falco'),
(12, 'FUNCTIONAL TRAINING', '2020-11-15', 'Felicia Falco');

-- --------------------------------------------------------

--
-- Struttura della tabella `ricetta`
--

CREATE TABLE `ricetta` (
  `username` varchar(20) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `ingredienti` varchar(200) DEFAULT NULL,
  `calorie` varchar(30) DEFAULT NULL,
  `grassi` varchar(30) DEFAULT NULL,
  `grassi_saturi` varchar(30) DEFAULT NULL,
  `carboidrati` varchar(30) DEFAULT NULL,
  `zuccheri` varchar(30) DEFAULT NULL,
  `proteine` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `ricetta`
--

INSERT INTO `ricetta` (`username`, `nome`, `ingredienti`, `calorie`, `grassi`, `grassi_saturi`, `carboidrati`, `zuccheri`, `proteine`) VALUES
('Erika2000', 'cena standard', '100g pane,200g pollo', '697kcal', '33.36g', '9.396999999999998g', '48.68g', '5.91g', '47.92g'),
('Erika2000', 'colazione salata', '50g pane,50g prosciutto', '214kcal', '5.92g', '1.8565g', '26.255g', '2.955g', '13.66g'),
('Erika2000', 'pasta asciutta', '100g pasta,50g olio', '813kcal', '51.51g', '3.9595000000000002g', '74.67g', '2.67g', '13.04g'),
('Erika2000', 'pranzo sabato', '100g pasta,80g pollo,1 mela', '637kcal', '13.867400000000002g', '3.77596g', '99.80420000000001g', '21.5798g', '28.3932g'),
('Franca97', 'pasta al pomodoro', '100g pasta,80g pomodoro,50g formaggio', '588kcal', '18.58g', '9.9834g', '78.447g', '4.914g', '25.764g'),
('Giuseppe02', 'caprese', '200g mozzarella,100g pomodoro', '618kcal', '44.900000000000006g', '26.331999999999997g', '8.27g', '4.6899999999999995g', '45.220000000000006g'),
('Giuseppe02', 'colazione lunedì', '100g cereali,120g yogurt', '410kcal', '5.4g', '2.8152g', '86.992g', '16.892g', '15.164g'),
('Giuseppe02', 'lunch thursday', '80g pasta,100g spinach', '319kcal', '1.5980000000000003g', '0.2846g', '63.36600000000001g', '2.556g', '13.292g'),
('Giuseppe02', 'panino sfizioso', '100g pane,200g prosciutto,80g formaggio', '917kcal', '47.495999999999995g', '22.1434g', '57.404g', '6.134g', '63.152g'),
('Giuseppe02', 'pasta e fagioli', '100g pasta,80g fagioli,50g formaggio', '598kcal', '18.596g', '10.001g', '80.91100000000002g', '5.418g', '26.524g'),
('Giuseppe02', 'pasta panna e salsiccia', '100g pasta,80g salsiccia,70g panna', '841kcal', '47.23400000000001g', '22.490600000000004g', '77.367g', '5.367000000000001g', '26.770999999999997g');

-- --------------------------------------------------------

--
-- Struttura della tabella `scheda`
--

CREATE TABLE `scheda` (
  `COD` int(11) NOT NULL,
  `cliente` int(11) NOT NULL,
  `istruttore` int(11) NOT NULL,
  `data` date DEFAULT NULL,
  `obiettivo` varchar(50) DEFAULT NULL,
  `durata` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `scheda`
--

INSERT INTO `scheda` (`COD`, `cliente`, `istruttore`, `data`, `obiettivo`, `durata`) VALUES
(1, 2, 3, '2020-12-15', 'TONIFICAZIONE', '4 settimane'),
(2, 4, 11, '2020-11-05', 'SCHEDA PROPEDEUTICA', '4 settimane'),
(3, 4, 3, '2020-11-27', 'IPERTROFIA', '8 settimane'),
(4, 9, 9, '2020-12-02', 'TONIFICAZIONE', '4 settiamane'),
(5, 9, 9, '2021-01-02', 'TONIFICAZIONE', '8 settiamane'),
(6, 10, 3, '2020-09-09', 'SCHEDA PROPEDEUTICA', '4 settimane'),
(7, 10, 9, '2020-10-10', 'IPERTROFIA', '8 settimane'),
(8, 10, 9, '2020-12-11', 'IPERTROFIA', '8 settimane'),
(9, 10, 11, '2021-01-12', 'PREPARAZIONE GARE', '28 settiamane');

-- --------------------------------------------------------

--
-- Struttura della tabella `segretario`
--

CREATE TABLE `segretario` (
  `ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `segretario`
--

INSERT INTO `segretario` (`ID`) VALUES
(1),
(2),
(5);

-- --------------------------------------------------------

--
-- Struttura della tabella `stage`
--

CREATE TABLE `stage` (
  `nome` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `stage`
--

INSERT INTO `stage` (`nome`) VALUES
('FUNCTIONAL TRAINING'),
('KARATE');

-- --------------------------------------------------------

--
-- Struttura della tabella `stage_organizzato`
--

CREATE TABLE `stage_organizzato` (
  `nome` varchar(30) NOT NULL,
  `data` date NOT NULL,
  `istruttore_esterno` varchar(50) NOT NULL,
  `orario` time DEFAULT NULL,
  `città` varchar(30) DEFAULT NULL,
  `sede` varchar(30) DEFAULT NULL,
  `via` varchar(30) DEFAULT NULL,
  `num_civico` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `stage_organizzato`
--

INSERT INTO `stage_organizzato` (`nome`, `data`, `istruttore_esterno`, `orario`, `città`, `sede`, `via`, `num_civico`) VALUES
('FUNCTIONAL TRAINING', '2020-09-22', 'Felicia Falco', '09:30:00', 'Messina', 'Palestra Fox', 'Crema', 34),
('FUNCTIONAL TRAINING', '2020-11-15', 'Felicia Falco', '10:30:00', 'Messina', 'Pala - Russello', 'Vico-Pietrasanta', 54),
('KARATE', '2020-10-15', 'Renato Cali', '10:00:00', 'Palermo', 'Palasport Fondo Patti', 'Castelforte', 58),
('KARATE', '2020-12-02', 'Edoardo Delfino', '09:00:00', 'Palermo', 'Kkienn Budo Club', 'Cardinale Mariano Rampolla', 4);

-- --------------------------------------------------------

--
-- Struttura per vista `info_cliente_abb`
--
DROP TABLE IF EXISTS `info_cliente_abb`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `info_cliente_abb`  AS SELECT `c`.`ID` AS `id_cl`, `c`.`CF` AS `CF_cl`, `c`.`nome` AS `nome_cl`, `c`.`cognome` AS `cognome_cl`, `a`.`COD` AS `cod_abb`, `a`.`corso` AS `corso_abb`, `a`.`tipo` AS `tipo_abb`, `a`.`data_inizio` AS `data_inizio_abb`, `a`.`quota` AS `quota_abb`, `a`.`scadenza` AS `scadenza_abb` FROM (`palestra`.`cliente` `c` join `palestra`.`abbonamento` `a` on(`c`.`ID` = `a`.`cliente`)) ;

-- --------------------------------------------------------

--
-- Struttura per vista `info_richiesta`
--
DROP TABLE IF EXISTS `info_richiesta`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `info_richiesta`  AS SELECT `c`.`ID` AS `id_cl`, `c`.`CF` AS `CF_cl`, `c`.`nome` AS `nome_cl`, `c`.`cognome` AS `cognome_cl`, `s`.`COD` AS `SCHEDA`, `s`.`data` AS `DATA`, `i`.`ID` AS `id_istr`, `d`.`CF` AS `CF_istr`, `d`.`nome` AS `nome_istr`, `d`.`cognome` AS `cognome_istr` FROM (((`palestra`.`cliente` `c` join `palestra`.`scheda` `s` on(`c`.`ID` = `s`.`cliente`)) join `palestra`.`istruttore` `i` on(`s`.`istruttore` = `i`.`ID`)) join `palestra`.`dipendente` `d` on(`i`.`ID` = `d`.`ID`)) ;

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `abbonamento`
--
ALTER TABLE `abbonamento`
  ADD PRIMARY KEY (`COD`,`cliente`,`corso`),
  ADD KEY `new_cliente` (`cliente`),
  ADD KEY `new_corso` (`corso`);

--
-- Indici per le tabelle `blocco_homepage`
--
ALTER TABLE `blocco_homepage`
  ADD PRIMARY KEY (`ID`);

--
-- Indici per le tabelle `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `new_id` (`ID`);

--
-- Indici per le tabelle `composizione`
--
ALTER TABLE `composizione`
  ADD PRIMARY KEY (`scheda`,`cliente`,`istruttore`,`esercizio`),
  ADD KEY `new_scheda` (`scheda`),
  ADD KEY `new_cliente` (`cliente`),
  ADD KEY `new_istruttore` (`istruttore`),
  ADD KEY `new_esercizio` (`esercizio`);

--
-- Indici per le tabelle `corso`
--
ALTER TABLE `corso`
  ADD PRIMARY KEY (`nome`);

--
-- Indici per le tabelle `dipendente`
--
ALTER TABLE `dipendente`
  ADD PRIMARY KEY (`ID`);

--
-- Indici per le tabelle `direttore`
--
ALTER TABLE `direttore`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `new_vice` (`vice`);

--
-- Indici per le tabelle `esercizio`
--
ALTER TABLE `esercizio`
  ADD PRIMARY KEY (`nome`);

--
-- Indici per le tabelle `insegnamento`
--
ALTER TABLE `insegnamento`
  ADD PRIMARY KEY (`istruttore`,`corso`),
  ADD KEY `new_istruttore` (`istruttore`),
  ADD KEY `new_corso` (`corso`);

--
-- Indici per le tabelle `insegnamento_passato`
--
ALTER TABLE `insegnamento_passato`
  ADD PRIMARY KEY (`istruttore`,`corso`),
  ADD KEY `new_istruttore` (`istruttore`),
  ADD KEY `new_corso` (`corso`);

--
-- Indici per le tabelle `istruttore`
--
ALTER TABLE `istruttore`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `new_id` (`ID`);

--
-- Indici per le tabelle `partecipa`
--
ALTER TABLE `partecipa`
  ADD PRIMARY KEY (`cliente`,`stage`,`data`,`istruttore_esterno`),
  ADD KEY `new_cliente` (`cliente`),
  ADD KEY `new_stage` (`stage`),
  ADD KEY `new_data` (`data`),
  ADD KEY `new_istr` (`istruttore_esterno`);

--
-- Indici per le tabelle `ricetta`
--
ALTER TABLE `ricetta`
  ADD PRIMARY KEY (`username`,`nome`);

--
-- Indici per le tabelle `scheda`
--
ALTER TABLE `scheda`
  ADD PRIMARY KEY (`COD`,`cliente`,`istruttore`),
  ADD KEY `new_cliente` (`cliente`),
  ADD KEY `new_istruttore` (`istruttore`);

--
-- Indici per le tabelle `segretario`
--
ALTER TABLE `segretario`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `new_id` (`ID`);

--
-- Indici per le tabelle `stage`
--
ALTER TABLE `stage`
  ADD PRIMARY KEY (`nome`);

--
-- Indici per le tabelle `stage_organizzato`
--
ALTER TABLE `stage_organizzato`
  ADD PRIMARY KEY (`nome`,`data`,`istruttore_esterno`),
  ADD KEY `new_nome` (`nome`),
  ADD KEY `new_data` (`data`),
  ADD KEY `new_istr` (`istruttore_esterno`);

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `abbonamento`
--
ALTER TABLE `abbonamento`
  MODIFY `COD` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT per la tabella `blocco_homepage`
--
ALTER TABLE `blocco_homepage`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT per la tabella `cliente`
--
ALTER TABLE `cliente`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- AUTO_INCREMENT per la tabella `dipendente`
--
ALTER TABLE `dipendente`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT per la tabella `direttore`
--
ALTER TABLE `direttore`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT per la tabella `istruttore`
--
ALTER TABLE `istruttore`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT per la tabella `scheda`
--
ALTER TABLE `scheda`
  MODIFY `COD` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT per la tabella `segretario`
--
ALTER TABLE `segretario`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `abbonamento`
--
ALTER TABLE `abbonamento`
  ADD CONSTRAINT `abbonamento_ibfk_1` FOREIGN KEY (`cliente`) REFERENCES `cliente` (`ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `abbonamento_ibfk_2` FOREIGN KEY (`corso`) REFERENCES `corso` (`nome`) ON UPDATE CASCADE;

--
-- Limiti per la tabella `composizione`
--
ALTER TABLE `composizione`
  ADD CONSTRAINT `composizione_ibfk_1` FOREIGN KEY (`scheda`) REFERENCES `scheda` (`COD`) ON UPDATE CASCADE,
  ADD CONSTRAINT `composizione_ibfk_2` FOREIGN KEY (`cliente`) REFERENCES `scheda` (`cliente`) ON UPDATE CASCADE,
  ADD CONSTRAINT `composizione_ibfk_3` FOREIGN KEY (`istruttore`) REFERENCES `scheda` (`istruttore`) ON UPDATE CASCADE,
  ADD CONSTRAINT `composizione_ibfk_4` FOREIGN KEY (`esercizio`) REFERENCES `esercizio` (`nome`) ON UPDATE CASCADE;

--
-- Limiti per la tabella `direttore`
--
ALTER TABLE `direttore`
  ADD CONSTRAINT `direttore_ibfk_1` FOREIGN KEY (`vice`) REFERENCES `segretario` (`ID`) ON UPDATE CASCADE;

--
-- Limiti per la tabella `insegnamento`
--
ALTER TABLE `insegnamento`
  ADD CONSTRAINT `insegnamento_ibfk_1` FOREIGN KEY (`istruttore`) REFERENCES `istruttore` (`ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `insegnamento_ibfk_2` FOREIGN KEY (`corso`) REFERENCES `corso` (`nome`) ON UPDATE CASCADE;

--
-- Limiti per la tabella `insegnamento_passato`
--
ALTER TABLE `insegnamento_passato`
  ADD CONSTRAINT `insegnamento_passato_ibfk_1` FOREIGN KEY (`istruttore`) REFERENCES `istruttore` (`ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `insegnamento_passato_ibfk_2` FOREIGN KEY (`corso`) REFERENCES `corso` (`nome`) ON UPDATE CASCADE;

--
-- Limiti per la tabella `istruttore`
--
ALTER TABLE `istruttore`
  ADD CONSTRAINT `istruttore_ibfk_1` FOREIGN KEY (`ID`) REFERENCES `dipendente` (`ID`) ON UPDATE CASCADE;

--
-- Limiti per la tabella `partecipa`
--
ALTER TABLE `partecipa`
  ADD CONSTRAINT `partecipa_ibfk_1` FOREIGN KEY (`cliente`) REFERENCES `cliente` (`ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `partecipa_ibfk_2` FOREIGN KEY (`stage`) REFERENCES `stage_organizzato` (`nome`) ON UPDATE CASCADE,
  ADD CONSTRAINT `partecipa_ibfk_3` FOREIGN KEY (`data`) REFERENCES `stage_organizzato` (`data`) ON UPDATE CASCADE,
  ADD CONSTRAINT `partecipa_ibfk_4` FOREIGN KEY (`istruttore_esterno`) REFERENCES `stage_organizzato` (`istruttore_esterno`) ON UPDATE CASCADE;

--
-- Limiti per la tabella `scheda`
--
ALTER TABLE `scheda`
  ADD CONSTRAINT `scheda_ibfk_1` FOREIGN KEY (`cliente`) REFERENCES `cliente` (`ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `scheda_ibfk_2` FOREIGN KEY (`istruttore`) REFERENCES `istruttore` (`ID`) ON UPDATE CASCADE;

--
-- Limiti per la tabella `segretario`
--
ALTER TABLE `segretario`
  ADD CONSTRAINT `segretario_ibfk_1` FOREIGN KEY (`ID`) REFERENCES `dipendente` (`ID`) ON UPDATE CASCADE;

--
-- Limiti per la tabella `stage_organizzato`
--
ALTER TABLE `stage_organizzato`
  ADD CONSTRAINT `stage_organizzato_ibfk_1` FOREIGN KEY (`nome`) REFERENCES `stage` (`nome`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
