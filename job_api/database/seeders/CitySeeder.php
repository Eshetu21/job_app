<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class CitySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('cities')->insert([


            ["name" =>         "Abomsa"],
            ["name" =>          "Adama"],
            ["name" =>    "Addis Ababa"],
            ["name" =>          "Agaro"],
            ["name" =>          "Alaba"],
            ["name" =>           "Ambo"],
            ["name" =>     "Arba Minch"],
            ["name" =>         "Asella"],
            ["name" =>         "Assosa"],
            ["name" =>         "Awassa"],
            ["name" =>          "Aykel"],
            ["name" =>           "Axum"],
            ["name" =>      "Bahir Dar"],
            ["name" =>         "Bedele"],
            ["name" =>         "Bedesa"],
            ["name" =>        "Bichena"],
            ["name" =>       "Bishoftu"],
            ["name" =>          "Bonga"],
            ["name" =>       "Butajira"],
            ["name" =>         "Chagni"],
            ["name" =>          "Chiro"],
            ["name" =>        "Dangila"],
            ["name" =>         "Debark"],
            ["name" =>   "Debre Berhan"],
            ["name" =>   "Debre Markos"],
            ["name" =>    "Debre Tabor"],
            ["name" =>      "Dembidolo"],
            ["name" =>         "Dessie"],
            ["name" =>           "Dila"],
            ["name" =>      "Dire Dawa"],
            ["name" =>         "Durame"],
            ["name" =>   "Finote Selam"],
            ["name" =>        "Gambela"],
            ["name" =>  "Gebre Guracha"],
            ["name" =>          "Gimbi"],
            ["name" =>          "Ginir"],
            ["name" =>           "Goba"],
            ["name" =>           "Gode"],
            ["name" =>         "Gondar"],
            ["name" =>  "Hagere Hiywet"],
            ["name" =>          "Harar"],
            ["name" =>        "Hawassa"],
            ["name" =>        "Hosaena"],
            ["name" =>         "Humera"],
            ["name" =>            "Imi"],
            ["name" =>          "Jimma"],
            ["name" =>         "Jijiga"],
            ["name" =>      "Kabri Dar"],
            ["name" =>         "Kemise"],
            ["name" =>           "Kobo"],
            ["name" =>          "Konso"],
            ["name" =>        "Mekelle"],
            ["name" =>          "Mendi"],
            ["name" =>          "Mettu"],
            ["name" =>           "Mojo"],
            ["name" =>        "Nekemte"],
            ["name" =>    "Negele Arsi"],
            ["name" =>  "Negele Borana"],
            ["name" =>          "Robit"],
            ["name" =>         "Sebeta"],
            ["name" =>     "Shashamane"],
            ["name" =>          "Shire"],
            ["name" =>           "Sodo"],
            ["name" =>        "Weldiya"],
            ["name" =>         "Werabe"],
            ["name" =>   "Wolaita Sodo"],
            ["name" =>         "Woliso"],
            ["name" =>          "Wukro"],
            ["name" =>         "Yabelo"],
            ["name" =>       "Yirgalem"],
            ["name" =>      "Zeway"],


        ]);
    }
}
