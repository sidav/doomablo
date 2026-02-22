class RarityIndicator : Actor
{
  Inventory attachItem;
  string lightId;
  int rarity;
  const zOffsFromAttached = 15.0;

  Default {
    +NOINTERACTION
    +NOBLOCKMAP
    +BRIGHT
    +MOVEWITHSECTOR
    Renderstyle 'AddShaded';
    Scale 0.25;
    Alpha 2.0;
  }

  static RarityIndicator Attach(Inventory item, int itmRarity) {
    if (!item || itmRarity < 1) return null;

    let ri = RarityIndicator(Spawn('RarityIndicator'));
    if (ri) {
      ri.attachItem = item;
      ri.rarity = itmRarity;
      ri.SetShade(RaritiesHelper.indicatorColorForRarity(ri.rarity));
      ri.Alpha = ri.alpha + 4 * (ri.fillcolor.b / 255.0); // Thanks Agent_Ash for the idea
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

  void attachLight() {
    if (lightId == "") {
      lightId = ""..rnd.randn(10000);
    }
    A_AttachLight(
      lightId,
      // DynamicLight.PointLight,
      DynamicLight.PulseLight,
      RaritiesHelper.indicatorColorForRarity(rarity),
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