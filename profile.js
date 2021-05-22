function onJsonAnagrafica(json){
    console.log('Questo è il JSON_ANAGRAFICA ricevuto:');
    console.log(json);

    const anagrafica = document.querySelector('#anagrafica');

    const nome = document.createElement('span');
    const cognome = document.createElement('span');
    const nascita = document.createElement('span');
    const CF = document.createElement('span');
    const email = document.createElement('span');
    const username = document.createElement('span');
    const password = document.createElement('span');

    nome.textContent = "Nome: " + json.nome;
    cognome.textContent = "Cognome: " + json.cognome;
    nascita.textContent = "Nascita: " + json.data_di_nascita;
    CF.textContent = "Codice Fiscale: " + json.CF;
    email.textContent = "Email: " + json.email;
    username.textContent = "Username: " + json.username;
    password.textContent = "Password: " + json.password;

    anagrafica.appendChild(nome);
    anagrafica.appendChild(cognome);
    anagrafica.appendChild(nascita);
    anagrafica.appendChild(CF);
    anagrafica.appendChild(email);
    anagrafica.appendChild(username);
    anagrafica.appendChild(password);
}

function onJsonAbbonamenti(json){
    console.log(json);

    const table_abbonamenti = document.querySelector('#abbonamenti table');
    for(let i=0;i<json.length;i++){
        const riga = document.createElement('tr')
        const corso = document.createElement('td');
        const tipo = document.createElement('td');
        const inizio = document.createElement('td');
        const fine = document.createElement('td');
        const quota = document.createElement('td');

        corso.textContent = json[i].corso;
        tipo.textContent = json[i].tipo;
        inizio.textContent = json[i].data_inizio;
        fine.textContent = json[i].scadenza;
        quota.textContent = json[i].quota;

        riga.appendChild(corso);
        riga.appendChild(tipo);
        riga.appendChild(inizio);
        riga.appendChild(fine);
        riga.appendChild(quota);
        table_abbonamenti.appendChild(riga);
    }
}

function onJsonSchede(json){
    console.log('Ecco il JSON schede');
    console.log(json);

    const container_schede = document.querySelector('#griglia');
    const table_intestaz = document.querySelector('#table_intestazioni');

    for(let i=0;i<json.length;i++){
        const intestaz = document.createElement('tr');
        const codice = document.createElement('td');
        const istruttore = document.createElement('td');
        const data = document.createElement('td');
        const obiettivo = document.createElement('td');
        const durata = document.createElement('td');

        codice.textContent = "CODICE SCHEDA: " + json[i].intestazione.COD;
        istruttore.textContent = "Istruttore: " + json[i].intestazione.nome_istruttore + " " + json[i].intestazione.cognome_istruttore;
        data.textContent = "Data di inizio: " + json[i].intestazione.data;
        obiettivo.textContent = "Obiettivo: " + json[i].intestazione.obiettivo;
        durata.textContent = "Durata: " + json[i].intestazione.durata;

        intestaz.appendChild(codice);
        intestaz.appendChild(istruttore);
        intestaz.appendChild(data);
        intestaz.appendChild(obiettivo);
        intestaz.appendChild(durata);
        table_intestaz.appendChild(intestaz);

        const composiz_scheda = document.createElement('table');

        const info = document.createElement('tr');
        const cod = document.createElement('th');
        const esercizio = document.createElement('th');
        const peso = document.createElement('th');
        const serie = document.createElement('th');
        const ripetizioni = document.createElement('th');

        cod.textContent = 'COD ' + json[i].intestazione.COD;
        cod.classList.add('cod');
        esercizio.textContent = "ESERCIZIO";
        peso.textContent = "PESO";
        serie.textContent = "SERIE";
        ripetizioni.textContent = "RIPETIZIONI";

        info.appendChild(cod);
        info.appendChild(esercizio);
        info.appendChild(peso);
        info.appendChild(serie);
        info.appendChild(ripetizioni);
        composiz_scheda.appendChild(info);

        for(let j=0;j<json[i].composizione.length;j++){
            const riga = document.createElement('tr');
            const empty = document.createElement('td');
            const n_esercizio = document.createElement('td');
            const n_peso = document.createElement('td');
            const n_serie = document.createElement('td');
            const n_ripetizioni = document.createElement('td');

            n_esercizio.textContent = json[i].composizione[j].esercizio;
            n_peso.textContent = json[i].composizione[j].peso;
            n_serie.textContent = json[i].composizione[j].serie;
            n_ripetizioni.textContent = json[i].composizione[j].ripetizioni;

            riga.appendChild(empty);
            riga.appendChild(n_esercizio);
            riga.appendChild(n_peso);
            riga.appendChild(n_serie);
            riga.appendChild(n_ripetizioni);
            composiz_scheda.appendChild(riga);
        }

        container_schede.appendChild(composiz_scheda);
    }
}

function onJsonStage(json){
    console.log('JSON stage ricevuto');
    console.log(json);

    //Se il json ha lunghezza 0 allora l'utente non ha partecipato/parteciperà ad alcuno stage
    if(json.length > 0) {
        const stage_container = document.querySelector('#stage');

        const table_stage = document.createElement('table');
        const riga_intestaz = document.createElement('tr');
        const nome = document.createElement('th');
        const data = document.createElement('th');
        const istruttore_esterno = document.createElement('th');
        const orario = document.createElement('th');
        const città = document.createElement('th');
        const sede = document.createElement('th');
        const via = document.createElement('th');
        const civico = document.createElement('th');

        nome.textContent = 'NOME';
        data.textContent = 'DATA';
        istruttore_esterno.textContent = 'ISTRUTTORE';
        orario.textContent = 'ORARIO';
        città.textContent = 'CITTA\'';
        sede.textContent = 'SEDE';
        via.textContent = 'VIA';
        civico.textContent = 'NUM_CIVICO';

        riga_intestaz.appendChild(nome);
        riga_intestaz.appendChild(data);
        riga_intestaz.appendChild(istruttore_esterno);
        riga_intestaz.appendChild(orario);
        riga_intestaz.appendChild(città);
        riga_intestaz.appendChild(sede);
        riga_intestaz.appendChild(via);
        riga_intestaz.appendChild(civico);

        table_stage.appendChild(riga_intestaz);

        for(let i=0;i<json.length;i++){
            const n_riga = document.createElement('tr');
            const n_nome = document.createElement('td');
            const n_data = document.createElement('td');
            const n_istruttore_esterno = document.createElement('td');
            const n_orario = document.createElement('td');
            const n_città = document.createElement('td');
            const n_sede = document.createElement('td');
            const n_via = document.createElement('td');
            const n_civico = document.createElement('td');

            n_nome.textContent = json[i].nome;
            n_data.textContent = json[i].data;
            n_istruttore_esterno.textContent = json[i].istruttore_esterno;
            n_orario.textContent = json[i].orario;
            n_città.textContent = json[i].città;
            n_sede.textContent = json[i].sede;
            n_via.textContent = json[i].via;
            n_civico.textContent = json[i].num_civico;

            n_riga.appendChild(n_nome);
            n_riga.appendChild(n_data);
            n_riga.appendChild(n_istruttore_esterno);
            n_riga.appendChild(n_orario);
            n_riga.appendChild(n_città);
            n_riga.appendChild(n_sede);
            n_riga.appendChild(n_via);
            n_riga.appendChild(n_civico);

            table_stage.appendChild(n_riga);
        }

        stage_container.appendChild(table_stage);
    }
}

function onResponseAnagrafica(response){
    console.log('DENTRO LA ONRESPONSE');
    return response.json();
}

function onResponseAbbonamenti(response){
    return response.json();
}

function onResponseSchede(response){
    return response.json();
}

function onResponseStage(response){
    return response.json();
}

function inserisciContenuto(){
    console.log("PRIMA DI FETCH");
    fetch('http://localhost/add_anagrafica.php').then(onResponseAnagrafica).then(onJsonAnagrafica);

    fetch('http://localhost/add_abbonamenti.php').then(onResponseAbbonamenti).then(onJsonAbbonamenti);

    fetch('http://localhost/add_schede.php').then(onResponseSchede).then(onJsonSchede);

    fetch('http://localhost/add_stage.php').then(onResponseStage).then(onJsonStage);
}

function mostraMenù(){
    const menù_account = document.querySelector('#menù_account');
    if(mostra===false){
        menù_account.classList.remove('hidden');
        mostra = true;
    }
    else {
        menù_account.classList.add('hidden');
        mostra = false;
    }
}

inserisciContenuto();

let mostra = false;

const account = document.querySelector('#account');
account.addEventListener('click',mostraMenù);

