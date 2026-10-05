-- 04: INNER JOIN, LEFT JOIN i veze više-prema-više

-- Knjiga i njen izdavač: samo postojeća poklapanja.
SELECT k.naziv AS knjiga, i.naziv AS izdavac
FROM knjige AS k
JOIN izdavaci AS i ON i.id = k.id_izdavaca
ORDER BY k.naziv;

-- Svi izdavači, čak i ako nemaju knjigu.
SELECT i.naziv AS izdavac,
       COUNT(k.id_knjige) AS broj_knjiga
FROM izdavaci AS i
LEFT JOIN knjige AS k ON k.id_izdavaca = i.id
GROUP BY i.id, i.naziv
ORDER BY broj_knjiga DESC, izdavac ASC;

-- Autori i njihove knjige preko pomoćne tabele knjige_autori.
SELECT a.ime || ' ' || a.prezime AS autor,
       k.naziv AS knjiga
FROM autori AS a
JOIN knjige_autori AS ka ON ka.id_autora = a.id
JOIN knjige AS k ON k.id_knjige = ka.id_knjige
ORDER BY autor, knjiga;

-- Ukupan iznos svake narudžbine.
SELECT n.id AS broj_narudzbine,
       ku.ime AS kupac,
       SUM(sn.kolicina * sn.cena_u_trenutku) AS ukupan_iznos
FROM narudzbine AS n
JOIN kupci AS ku ON ku.id = n.id_kupca
JOIN stavke_narudzbine AS sn ON sn.id_narudzbine = n.id
GROUP BY n.id, ku.ime
ORDER BY n.id;
