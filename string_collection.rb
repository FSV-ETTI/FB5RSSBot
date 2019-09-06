# Piet Lipke
# 2019

# Contains some strings and stuff.
class StringCollection
  # Keyboard buttons.
  def keyboard_string
    %w[
        Alle\ Nachrichten\ |\ Abonniert
    ]
  end

  def keyboard_strings
    %w[
      Alle\ Nachrichten
      Dekanat
      Artificial\ Intelligence\ in\ Automation
      Bauelemente\ und\ Hardware-Design
      Digitale\ Kommunikationssysteme
      Diskrete\ Systeme
      Echtzeitsysteme
      Elektrische\ Energietechnik
      Hochfrequenztechnik
      Human-Computer\ Interaction
      Informationstechnologie
      IT-Sicherheit
      Leistungselektronik\ und\ Elektrische\ Antriebe
      Messtechnik
      Netzwerktechnik
      Optical\ Engineering
      Simulation\ technischer\ Systeme
      Info\ der\ Fachschaft
    ]
  end

  # Array containing all RSS urls.
  def monitors
    %w[
      https://www.th-owl.de/fb5/fb5.rss
      https://www.th-owl.de/fb5/fb5-dek-infos.rss
      https://www.th-owl.de/fb5/fb5-es-infos.rss
      https://www.th-owl.de/fb5/fb5-hd-infos.rss
      https://www.th-owl.de/fb5/fb5-dk-infos.rss
      https://www.th-owl.de/fb5/fb5-ds-infos.rss
      https://www.th-owl.de/fb5/fb5-ez-infos.rss
      https://www.th-owl.de/fb5/fb5-ee-infos.rss
      https://www.th-owl.de/fb5/fb5-hf-infos.rss
      https://www.th-owl.de/fb5/fb5-hci-infos.rss
      https://www.th-owl.de/fb5/fb5-it-infos.rss
      https://www.th-owl.de/fb5/fb5-its-infos.rss
      https://www.th-owl.de/fb5/fb5-la-infos.rss
      https://www.th-owl.de/fb5/fb5-mt-infos.rss
      https://www.th-owl.de/fb5/fb5-ne-infos.rss
      https://www.th-owl.de/fb5/fb5-oe-infos.rss
      https://www.th-owl.de/fb5/fb5-simts-infos.rss
      https://www.th-owl.de/fb5/fb5-fachschaft-infos.rss
    ]
  end

  # Array containing the keys for database.
  def keys
    %w[
      AlleNachrichten
      Dekanat
      ArtificialIntelligenceInAutomation
      BauelementeUndHardwareDesign
      DigitaleKommunikationssysteme
      DiskreteSysteme
      Echtzeitsysteme
      ElektrischeEnergietechnik
      Hochfrequenztechnik
      HumanComputerInteraction
      Informationstechnologie
      ITSicherheit
      LeistungselektronikUndElektrischeAntriebe
      Messtechnik
      Netzwerktechnik
      OpticalEngineering
      SimulationTechnischerSysteme
      InfoDerFachschaft
    ]
  end

  # Hash used to find the Key of the users database.
  # Assignment branch is pretty high if replaced by method references.
  def hash_monitors
    Hash[
        'https://www.th-owl.de/fb5/fb5.rss' =>
            'AlleNachrichten',
        'https://www.th-owl.de/fb5/fb5-dek-infos.rss' =>
            'Dekanat',
        'https://www.th-owl.de/fb5/fb5-es-infos.rss' =>
            'ArtificialIntelligenceInAutomation',
        'https://www.th-owl.de/fb5/fb5-hd-infos.rss' =>
            'BauelementeUndHardwareDesign',
        'https://www.th-owl.de/fb5/fb5-dk-infos.rss' =>
            'DigitaleKommunikationssysteme',
        'https://www.th-owl.de/fb5/fb5-ds-infos.rss' =>
            'DiskreteSysteme',
        'https://www.th-owl.de/fb5/fb5-ez-infos.rss' =>
            'Echtzeitsysteme',
        'https://www.th-owl.de/fb5/fb5-ee-infos.rss' =>
            'ElektrischeEnergietechnik',
        'https://www.th-owl.de/fb5/fb5-hf-infos.rss' =>
            'Hochfrequenztechnik',
        'https://www.th-owl.de/fb5/fb5-hci-infos.rss' =>
            'HumanComputerInteraction',
        'https://www.th-owl.de/fb5/fb5-it-infos.rss' =>
            'Informationstechnologie',
        'https://www.th-owl.de/fb5/fb5-its-infos.rss' =>
            'ITSicherheit',
        'https://www.th-owl.de/fb5/fb5-la-infos.rss' =>
            'LeistungselektronikUndElektrischeAntriebe',
        'https://www.th-owl.de/fb5/fb5-mt-infos.rss' =>
            'Messtechnik',
        'https://www.th-owl.de/fb5/fb5-ne-infos.rss' =>
            'Netzwerktechnik',
        'https://www.th-owl.de/fb5/fb5-oe-infos.rss' =>
            'OpticalEngineering',
        'https://www.th-owl.de/fb5/fb5-simts-infos.rss' =>
            'SimulationTechnischerSysteme',
        'https://www.th-owl.de/fb5/fb5-fachschaft-infos.rss' =>
            'InfoDerFachschaft'
    ]
  end
end