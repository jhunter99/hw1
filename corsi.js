function onJson(json){
    console.log('Ecco il JSON');
    console.log(json);
    const griglia = document.querySelector('.griglia');

    const ArrayOrdine = [4, 5, 0, 2, 3, 1];
    for(let i=0;i<ArrayOrdine.length;i++){
        const blocco = document.createElement('div');
        const blocco_info = document.createElement('div');
        const image = document.createElement('img');
        const title = document.createElement('h2');
        const num_iscritti = document.createElement('span');
        
        image.src = json[ArrayOrdine[i]].image_url;
        title.textContent = json[ArrayOrdine[i]].nome;
        num_iscritti.textContent = "Clienti iscritti: " + json[ArrayOrdine[i]].num_iscritti;

        blocco.classList.add('block');
        blocco.appendChild(image);
        blocco.appendChild(title);
        blocco_info.classList.add('info');
        blocco_info.appendChild(num_iscritti);

        for(let j=0;j<json[ArrayOrdine[i]]['istruttori'].length;j++){
            const istruttore = document.createElement('span');
            const formaz_istr = document.createElement('span');
            istruttore.textContent = "Istruttore: " + json[ArrayOrdine[i]]['istruttori'][j].nome;
            formaz_istr.textContent = "Formazione: " + json[ArrayOrdine[i]]['istruttori'][j].formazione;

            istruttore.classList.add('moreSpaceTop');
            formaz_istr.classList.add('moreSpaceDown');
            blocco_info.appendChild(istruttore);
            blocco_info.appendChild(formaz_istr);
        }

        blocco.appendChild(blocco_info);
        griglia.appendChild(blocco);
    }
}

function onResponse(response){
    return response.json();
}

function inserisciContenuto(){
    const griglia = document.querySelector('.griglia');
    fetch('add_blocchi_corsi.php').then(onResponse).then(onJson);
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

let mostra = false;

inserisciContenuto();

const account = document.querySelector('#account');
account.addEventListener('click',mostraMenù);