<?php
	try {
		$connection = new PDO("mysql:host=localhost;dbname=id19496501_test", "id19496501_flutter", "Deco3801Project!");
		// $connection ->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        // echo "CONNECTED";

	} catch (PDOException $exc) {
		echo $exc->getMessage();
	}
?>