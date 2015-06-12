vaalikone-lda
===================
Tästä Github-repositorysta löytyy skriptejä joilla voidaan analysoida Ylen vuoden 2015 Vaalikone-vastausten avoimia kysymyksiä n.s. Latent Dirichlet Allocation-menetelmällä. Lopullista visualisaatiota voi tarkastella [tästä](http://nbviewer.ipython.org/github/wallinm1/vaalikone-lda/blob/master/vaalikone_lda.ipynb) linkistä (Github ei ainakaan vielä renderaa interaktiivisia Jupyter notebookeja).

## Data
Analyysin lähdedatana käytetään Ylen avoimeksi tekemää [Vaalikone-dataa](http://yle.fi/uutiset/yle_julkaisee_vaalikoneen_vastaukset_avoimena_datana/7869597).  Tästä datasta olen käyttänyt versiota joka löytyy [avoindata.fi-sivuilta](https://www.avoindata.fi/data/fi/dataset/eduskuntavaalien-2015-ylen-vaalikoneen-vastaukset-ja-ehdokkaiden-taustatiedot).

Avoindata.fi:n hostaamaan aineistoon on eksynyt yksi enkoodaus-virhe joka piti korjata käsin jotta .csv-tiedoston pystyisi onnistuneesti lukemaan utf-8-enkoodauksella. SDP:n Raimo Piiraisen vastauksesta (vastausid 4798, rivi 1358) pitää poistaa merkki 伋 joka löytyy aika loppupuolelta Piiraisen vastauksia (tekstinpätkän `vaan ilmastonmuutoksen hyväksi on työskenneltävä pitkällä aikavälillä` jälkeen ja ennen pätkää `Nykyisille periaateluvan saanneille ydinvoimaloille`). Kun tämä virhe on korjattu, sijoita .csv-tiedosto nimellä `vaalikone_data_fix.csv` data-kansioon.

##Kirjastot
`gen_model.R`-skripti käyttää kirjastoja `tm`, `RWeka`, `lda`,`LDAvis` ja `jsonlite`. Kaikki nämä kirjastot voi asentaa CRAN:ista, eli esim. ajamalla R-konsolissa koodinpätkä
``
install.packages('tm')
install.packages('RWeka')
install.packages('lda')
install.packages('LDAvis')
install.packages('jsonlite')
``
Jupyter notebook-tiedosto `vaalikone_lda.ipynb` käyttää kahta kirjastoa jotka eivät kuulu Pythonin standardikirjastoihin, eli `numpy`- ja `pyLDAvis`. Lisäksi Jupyter-notebookin ajamiseen tarvitaan `ipython`. Ehkä helpoin tapa asentaa tarvittavat python-kirjastot on [Anaconda-distron](http://continuum.io/downloads) kautta. Tuo distro sisältää itsessään jo `numpy`- ja `ipython`-kirjastot, ja puuttuvan `pyLDAvis`-kirjaston voi asentaa esim komennolla `pip install pyLDAvis`.

Omissa yritelmissäni vaikutti siltä ettei `pyLDAvis` oikein toimi Windowsilla, mutta esimerkiksi Ubuntu 14.04 LTS:llä kirjasto vaikuttaa toimivan ihan niin kuin pitää.

## Jupyter notebookin ajaminen
1. Korjaa lähdedata `Data`-osion ohjeiden mukaan ja sijoita nimellä nimellä `vaalikone_data_fix.csv` data-kansioon.
2. Aja `gen_model.R`-skripti. Tässä menee sellaiset 30-60 min. Ajoa voi nopeuttaa huomattavasti pienentämällä `K`- ja `G`-parametrien arvoja riveillä 60 ja 61.
3. Siirry `vaalikone-lda`-kansioon ja käynnistä Jupyter notebook komennolla `ipython notebook vaalikone_lda.ipynb`.
