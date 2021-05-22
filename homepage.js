function onJsonContenuto(json){
    console.log('Questo è il JSON ricevuto:');
    console.log(json);

    const grid = document.querySelector('.griglia');
    for (let i=0; i<json.length;i++){
        const blocco = document.createElement('div');
        const title = document.createElement('h1');
        const image = document.createElement('img');
        const description = document.createElement('div');
        const moreDetails = document.createElement('button');
        const lessDetails = document.createElement('button');
        const star = document.createElement('button');

        title.textContent = json[i].title;
        image.src = json[i].image_src;
        description.textContent = json[i].description;
        moreDetails.textContent = 'Mostra più dettagli';
        lessDetails.textContent = 'Mostra meno dettagli';
    
        description.classList.add('hidden');
        lessDetails.classList.add('hidden');
        moreDetails.classList.add('dettagli_più');
        lessDetails.classList.add('dettagli_meno');
        star.classList.add('star');

        moreDetails.addEventListener('click',mostraTesto);
        lessDetails.addEventListener('click',nascondiTesto);
        star.addEventListener('click',aggiungiPreferiti);
        
        blocco.appendChild(image);
        blocco.appendChild(title);
        blocco.appendChild(description);
        blocco.appendChild(star);
        blocco.appendChild(moreDetails);
        blocco.appendChild(lessDetails);
        grid.appendChild(blocco);
    }

}

function onResponseContenuto(response){
    return response.json();
}

function inserisciContenuto(){
    fetch('add_blocchi_homepage.php').then(onResponseContenuto).then(onJsonContenuto);
}

function onJsonPubblicità(json){
    console.log('JSON ricevuto');
    console.log(json);
    const container = document.querySelector('#container');
    for(let i=0;i<json.length;i++){
        const product = json[i];

        const blocco = document.createElement('div');
        const image = document.createElement('img');
        const title = document.createElement('span');
        const price = document.createElement('span');

        image.src = product.image_url;
        title.textContent = product.product_name;
        price.textContent = '$' + product.current_price;
        price.classList.add('bold');

        blocco.appendChild(image);
        blocco.appendChild(title);
        blocco.appendChild(price);

        container.appendChild(blocco);
    }
}

function onResponsePubblicità(response) {
    console.log('Risposta ricevuta!');
    return response.json();
}

function inserisciPubblicità(){
    fetch('amazon_api.php').then(onResponsePubblicità).then(onJsonPubblicità);
}

function mostraTesto(event) {
    console.log('mostraTesto invocata');
    const bottone = event.currentTarget;
    const testo = bottone.parentNode.querySelector('div');
    const lessDetails = bottone.parentNode.querySelector('.dettagli_meno')

    bottone.classList.add('hidden');
    testo.classList.remove('hidden');
    lessDetails.classList.remove('hidden');
}

function nascondiTesto(event){
    const bottone = event.currentTarget;
    const testo = bottone.parentNode.querySelector('div');
    const moreDetails = bottone.parentNode.querySelector('.dettagli_più')

    bottone.classList.add('hidden');
    testo.classList.add('hidden');
    moreDetails.classList.remove('hidden');
}

function rimuoviPreferiti(event){
    const button = event.currentTarget;
    const titoli = document.querySelectorAll('.griglia div h1')

    /*Prima di rimuovere il blocco dai preferiti, DEVO riabilitare l'aggiunta ai preferiti al corrispodente blocco della Section*/
    for(titolo of titoli){
        if((titolo.textContent.indexOf(button.parentNode.querySelector('h1').textContent))!==-1){
            titolo.parentNode.querySelector('.star').addEventListener('click',aggiungiPreferiti);
            break;
        }
    }
    
    button.parentNode.remove();

    const prefer = document.querySelector('#preferences');
    const blocchi_pref = prefer.querySelector('div');
    if(!blocchi_pref){
        prefer.classList.remove('preferiti');
        prefer.classList.add('hidden');
        document.querySelector('.intestazione').classList.add('hidden');
    } 
}

function aggiungiPreferiti(event){
    const bottone_pref = event.currentTarget;
    const sezione_pref = document.querySelector('#preferences');
    const titolo = bottone_pref.parentNode.querySelector('h1');
    const img = bottone_pref.parentNode.querySelector('img');

    let blocco_pref = document.createElement('div');
    const titolo_pref = document.createElement('h1');
    const img_pref = document.createElement('img');
    const star_selected = document.createElement('button');
    const intestaz = document.querySelector('.intestazione');

    sezione_pref.classList.remove('hidden');
    sezione_pref.classList.add('preferiti');
    intestaz.classList.remove('hidden');

    titolo_pref.textContent = titolo.textContent;
    img_pref.src = img.src;
    star_selected.classList.add('selected');

    blocco_pref.appendChild(img_pref);
    blocco_pref.appendChild(titolo_pref);
    blocco_pref.appendChild(star_selected);
    sezione_pref.appendChild(blocco_pref);
    bottone_pref.removeEventListener('click',aggiungiPreferiti);
    star_selected.addEventListener('click',rimuoviPreferiti);
}

function search(event) {
    const text_barra = event.currentTarget.value;
    const titoli = document.querySelectorAll('.griglia div h1');

    for(titolo of titoli){
        titolo.parentNode.classList.add('hidden')
    }

    for(titolo of titoli){
        if((titolo.textContent.toUpperCase().indexOf(text_barra.toUpperCase()))!==-1){
            titolo.parentNode.classList.remove('hidden');
        }
    }
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
inserisciPubblicità();

let mostra = false;

const barra = document.querySelector('#cerca input');
barra.addEventListener('keyup',search);

const account = document.querySelector('#account');
account.addEventListener('click',mostraMenù);