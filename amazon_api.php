<?php
	$apihost = "amazon-product-price-data.p.rapidapi.com";
	$apikey = "9d774d61bdmsh348f077b5608a7cp19a621jsncdfc223328d2";

	$query = urlencode("B000GISTZ4,B01LZ2UP91,B07N64YD2Y,B009VV7G60,B0734CCWGR");

	$curl = curl_init();

	curl_setopt($curl, CURLOPT_URL, "https://amazon-product-price-data.p.rapidapi.com/product?asins=" . $query . "&locale=US");
	curl_setopt($curl, CURLOPT_HTTPHEADER, ["x-rapidapi-host: $apihost", "x-rapidapi-key: $apikey"]);
	curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);

	$result = curl_exec($curl);
	echo $result;
	curl_close($curl);
?>



