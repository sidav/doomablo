class RarityIndicator : Actor
{
  Inventory attachItem;
  string lightId;
  int rarity;
  const zOffsFromAttached = 17.5;

  Default {
    +NOINTERACTION
    +NOBLOCKMAP
    +BRIGHT
    Renderstyle 'Shaded';
    Scale 0.25;
    Alpha 0.45;
  }

  static RarityIndicator Attach(Inventory item, int itmRarity) {
    if (!item || itmRarity < 1) return null;

    let ri = RarityIndicator(Spawn('RarityIndicator'));
    if (ri) {
      ri.attachItem = item;
      ri.rarity = itmRarity;
      ri.SetShade(colorForRarity(ri.rarity));
      ri.A_ChangeLinkFlags(sector: true); // Hide by default
    }
    return ri;
  }

  override void Tick() {
    if (!attachItem) {
      Destroy();
      return;
    }
    if (!attachItem.bNoSector && bNoSector) {
      attachLight();
      A_ChangeLinkFlags(sector: false);
    }
    if (attachItem.bNosector && !bNoSector) {
      removeLight();
      A_ChangeLinkFlags(sector: true);
    }
    if (!bNoSector) {
      SetOrigin(attachItem.pos.PlusZ(zOffsFromAttached), true);
    }
  }

  static Color colorForRarity(int rarity) {
    switch (rarity) {
        case 0: return 0xFFFFFF;
        case 1: return 0x00FF00;
        case 2: return 0x0000BB;
        case 3: return 0xFF00BB;
        case 4: return 0xFFFF00;
        case 5: return 0x55BBBB;
    }
    return 0xff00ff;
  }

  void attachLight() {
    if (lightId == "") {
      lightId = ""..rnd.randn(10000);
    }
    A_AttachLight(
      lightId,
      // DynamicLight.PointLight,
      DynamicLight.PulseLight,
      colorForRarity(rarity),
      1,
      15,
      param: 3.0
    );
  }

  void removeLight() {
    A_RemoveLight(lightId);
  }

  States {
  Spawn:
    RARI A -1;
    stop;
  }
}