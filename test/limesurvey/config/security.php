<?php if (!defined('BASEPATH')) exit('No direct script access allowed');
/*
 * LimeSurvey
 * Copyright (C) 2007-2019 The LimeSurvey Project Team / Carsten Schmitz
 * All rights reserved.
 * License: GNU/GPL License v3 or later, see LICENSE.php
 * LimeSurvey is free software. This version may have been modified pursuant
 * to the GNU General Public License, and as distributed it includes or
 * is derivative of works licensed under the GNU General Public License or
 * other free or open source software licenses.
 * See COPYRIGHT.php for copyright notices and details.
 */

/* 
WARNING!!!
ONCE SET, ENCRYPTION KEYS SHOULD NEVER BE CHANGED, OTHERWISE ALL ENCRYPTED DATA COULD BE LOST !!!

*/

$config = array();
$config['encryptionnonce'] = 'a4569802c793875288832c728927d448cc16448d8c77ee58';
$config['encryptionsecretboxkey'] = '9e816afa0d67af3618654839bbc8012723942020c84affdfd4fab9b4ac84bd54';
return $config;