---
layout: post
title:  "Portainer"
author: "Jarda"
description: WEB GUI pro správu Docker kontejnerů. Jak ho nasadit přes Ansible a napojit do Homepage.
categories: 
    - Homelab
tags: 
    - Portainer
    - Docker
thumbnail: /assets/portainer_logo.svg
---

- [Portainer](#portainer)
  - [Prvotní inicializace](#prvotní-inicializace)
  - [Připojení Portaineru do Homepage](#připojení-portaineru-do-homepage)
    - [Jak zjistit ID lokálního Docker prostředí v Portaineru](#jak-zjistit-id-lokálního-docker-prostředí-v-portaineru)
    - [Získání API tokenu pro Homepage](#získání-api-tokenu-pro-homepage)

# Portainer

- [portainer](https://www.portainer.io/)

Portainer je GUI pro správu Docker kontejnerů. Můžete ho nainstalovat v Proxmoxu jako kontejner a pak přes něj spravovat všechny vaše kontejnery (Radarr, Sonarr, Bazarr, Jellyfin, Audiobookshelf, Kavitu, atd.) a to bez nutnosti sahat do příkazové řádky!

Pokud jako správný sysadmin chcete mít v sekci "Infrastructure" klikací dlaždici a rovnou na ní vidět celkové statistiky (např. počty běžících/zastavených kontejnerů, zátěž stroje), tak jej lze napojenit na widget v Homepage. Kde pak u jeho dlaždice zavoláte `widget: type: portainer`. Na dlaždici se vám pak přehledně vykreslí celkový počet běžících, zastavených a celkových kontejnerů.

## Prvotní inicializace
Po nasazení přes Ansible pomocí mé systemd šablony jsem otevřel [http://192.168.1.101:9000](http://192.168.1.101:9000). Portainer vás při prvním načtení vyzve k vytvoření administrátorského hesla. Udělej to co nejdříve, z bezpečnostních důvodů má Portainer časový limit (asi 5 minut) od startu kontejneru. Pokud to nestihnete, kontejner se zablokuje a musíte jej restartovat.

Pro registraci potřebujete v logu kontejneru najít dočasný token, který se zobrazí jen při prvním startu kontejneru. 

```bash
docker logs portainer
```

{: .info }
> Z prvu se mi Portainer zdál v homelabu zbytečný, ale jak začali přibývat kontejnery, tak byl užitečnější čím dál tím více. Hodně užitečné se mi zdá kombinace zobrazení logu z kontejneru + možnost jeho restartu přímo z webového rozhraní. A to vše bez nutnosti sahat do příkazové řádky.

## Připojení Portaineru do Homepage

Otevřete `services.yaml` a přidejte Portainer jako novou službu do sekce infrastruktury. Parametr `env: 1` označuje ID lokálního Docker prostředí uvnitř Portaineru (u čisté instalace je to vždy 1).

```YAML
- Infrastructure:
  - Portainer:
      icon: si-portainer
      href: http://192.168.1.101:9000
      description: Sprava Docker kontejneru
      widget:
        type: portainer
        url: http://192.168.1.101:9000
        env: <endpoint_id>
        key: <token>
```

{: .warning }
> Tokeny a hesla negitujte, ale použite buďto Ansible Vault nebo je uložte do `.env` souboru a v `services.yaml` použijte proměnné prostředí!

### Jak zjistit ID lokálního Docker prostředí v Portaineru

Klikněte na local a podívejte se do url, je tam číslo ID lokálního Docker prostředí (např. `http://192.168.1.101:9000/#!/endpoints/1`).

Pokud nemáte prostředí local, nové vytvořte:
1. V levém panelu Portaineru klikněte na **Environments** (Prostředí).
2. Vpravo nahoře klikněte na modré tlačítko **Add environment**.
3. Z nabídky vyberte **Docker Standalone** a dole klikněte na **Start Wizard**.
4. Zvolte metodu připojení Socket (přesně ten jsme mu totiž do kontejneru přidali).
5. Do pole Name si to prostředí libovolně pojmenuj (např. local nebo `docker-runner`).
6. Klikněte na **Connect**.

V prohlížeči se vám zobrazí: `http://192.168.1.101:9000/#!/endpoints/2` (číslo **2** je ID lokálního Docker prostředí). To číslo si poznamenej, bude se ti hodit pro integraci do Homepage.

### Získání API tokenu pro Homepage
Aby Homepage mohla vyčítat celkové statistiky, potřebuje od Portaineru klíč:

1. V Portaineru klikněte vpravo nahoře na váš uživatelský profil -> **My account**.
2. Sjeď dolů do sekce **Access tokens** a vygeneruj nový token (např. s názvem "Homepage").
3. Hodnotu tokenu si zkopírujte, ukáže se vám jen jednou.

Po aktualizaci Homepage se vám na dlaždici Portaineru objeví ten vytoužený celkový počet běžících, zastavených a celkových kontejnerů.