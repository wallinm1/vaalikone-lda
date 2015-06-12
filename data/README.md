Lataa avoindata.fi:n hostaama Ylen [Vaalikone-data](https://www.avoindata.fi/data/fi/dataset/eduskuntavaalien-2015-ylen-vaalikoneen-vastaukset-ja-ehdokkaiden-taustatiedot). 

Poista SDP:n Raimo Piiraisen vastauksesta (vastausid 4798, rivi 1358) merkki 伋 joka löytyy aika loppupuolelta Piiraisen vastauksia (tekstinpätkän `vaan ilmastonmuutoksen hyväksi on työskenneltävä pitkällä aikavälillä` jälkeen ja ennen pätkää `Nykyisille periaateluvan saanneille ydinvoimaloille`). 

Sijoita korjattu .csv-tiedosto nimellä `vaalikone_data_fix.csv` tähän data-kansioon.

`gen_model.R`-skripti tulee luomaan tähän kansioon visualisaation käyttämän json-tiedoston.