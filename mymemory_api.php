<?php
    $apihost = "translated-mymemory---translation-memory.p.rapidapi.com";
    $apikey = "9d774d61bdmsh348f077b5608a7cp19a621jsncdfc223328d2";

    $query = urlencode($_GET['q']);

    $curl = curl_init();

    curl_setopt($curl, CURLOPT_URL, "https://translated-mymemory---translation-memory.p.rapidapi.com/api/get?q=" . $query . "&langpair=it%7Cen&de=a%40b.c&onlyprivate=0&mt=1");
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($curl, CURLOPT_HTTPHEADER, ["x-rapidapi-host: $apihost", "x-rapidapi-key: $apikey"]);

    $result = curl_exec($curl);
    echo $result;
    curl_close($curl);
?>

