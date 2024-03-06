-- Keep a log of any SQL queries you execute as you solve the mystery.

--the theft happened 7/28/2021 based on the crime scene report
SELECT description FROM crime_scene_reports
WHERE year = 2021 AND month = 7 AND day = 28;

--there's three witnesses that mentioned the bakery at Humphrey street and all of the witnesses mentioned it happened around 10:15am
SELECT transcript FROM interviews
WHERE year = 2021 AND month = 7 AND day = 28 AND transcript LIKE "%bakery%";

--sometime within ten minutes of the theft, one of the witnesses saw the thief went to the parking lot and drove away, he mentioned about the bakery security camera.
--looking for the cars that left and run license plates with the registered driver.
SELECT bakery_security_logs.activity, bakery_security_logs.license_plate, people.name FROM people
JOIN bakery_security_logs ON bakery_security_logs.license_plate = people.license_plate
WHERE bakery_security_logs.year = 2021
AND bakery_security_logs.month = 7
AND bakery_security_logs.day = 28
AND bakery_security_logs.hour = 10
AND bakery_security_logs.minute >= 15
AND bakery_security_logs.minute <= 25;

--the other witness mentioned about seeing the thief walking by the ATM on Leggett St withdrawing money.
--will run the transaction at the ATM to connect the people lesving the parking lot from the bakery.

SELECT people.name, atm_transactions.transaction_type FROM people
JOIN bank_accounts ON bank_accounts.person_id = people.id
JOIN atm_transactions ON atm_transactions.account_number = bank_accounts.account_number
WHERE atm_transactions.year = 2021
AND atm_transactions.month = 7
AND atm_transactions.day = 28
AND atm_location = "Leggett Street"
AND atm_transactions.transaction_type = "withdraw";

--based on the ATM transaction and the people leaving the parking lot there's three people that matched.
--names involve so far is Bruce,Diana,Luca and Iman.
--one of the witnesses mentioned something about the thief calling someone and talked for less than a minute
--and taking the earliest flight out of Fiftyville tomorrow,
--the thief prompted the accomplice to purchase the flight ticket.
--will track the call and the person who is going to purchase the ticket of the earliest flight out of fiftyville

SELECT name FROM people
JOIN passengers ON passengers.passport_number = people.passport_number
WHERE passengers.flight_id = (
SELECT id FROM flights
WHERE year = 2021
AND month = 7
AND day = 29
AND origin_airport_id = (
SELECT id FROM airports WHERE city = "Fiftyville")
ORDER BY hour,minute
LIMIT 1);

-- suspects Bruce and Luca

SELECT name FROM people
JOIN phone_calls ON phone_calls.caller = people.phone_number
WHERE year = 2021
AND month = 7
ANd day = 28
AND duration <60;

--BRUCE is the THIEF! we just have to find out which city Bruce went to and who is the accomplice with this crime.
SELECT city FROM airports
WHERE id = (SELECT destination_airport_id FROM flights
WHERE year = 2021
AND month = 7
AND day = 29
AND origin_airport_id = (
SELECT id FROM airports WHERE city = "Fiftyville")
ORDER BY hour, minute
LIMIT 1);

SELECT phone_number FROM people WHERE name = "Bruce";


SELECT name FROM people WHERE phone_number = (
SELECT receiver FROM phone_calls
WHERE year = 2021
AND month = 7
AND day = 28
AND duration < 60
AND caller = "(367) 555-5533");