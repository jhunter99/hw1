function validazione(event){
    // Verifica se tutti i campi sono riempiti
    if(form.CF.value.length == 0 || form.nome.value.length == 0 || form.cognome.value.length == 0 || form.nascita.value.length == 0 ||
    form.età.value.length == 0 || form.email.value.length == 0 || form.username.value.length == 0 || form.password.value.length == 0 ||
    form.corso.value.length == 0 || form.tipo_abbonamento.value.length == 0 || form.data_inizio.value.length == 0)
    {
        document.querySelector('#error').classList.remove('hidden');
        event.preventDefault();
    }
}

const form = document.forms['registrazione'];
form.addEventListener('submit', validazione);
