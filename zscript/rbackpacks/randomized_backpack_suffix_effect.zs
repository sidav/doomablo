extend class RwBackpack {

    override void DoEffect() {
        super.DoEffect();
        
        let age = GetAge();

        let aff = findAppliedAffix('BSuffRestoreCells');
        if (aff != null) {
            if (age % aff.modifierLevel == 0) {
                owner.GiveInventory('Cell', 1);
            }
            return; // There may be no other suffix anyway
        }

        aff = findAppliedAffix('BSuffNoisy');
        if (aff != null) {
            if (age % (TICRATE * 5) == 0 && rnd.PercentChance(aff.modifierLevel)) {
                // Iterate through all monsters
                let ti = ThinkerIterator.Create('Actor');
                Actor mo;
                while (mo = Actor(ti.next())) {
                    if (mo && mo.bIsMonster && mo.target == null && mo.CheckSight(owner, SF_IGNOREWATERBOUNDARY)) {
                        mo.target = owner;
                        // Rotation 3 times 45 degrees each
                        for (let i = 0; i < 3; i++) {
                            mo.A_Chase();
                        }
                    }
                }
            }
            return; // There may be no other suffix anyway
        }

        aff = findAppliedAffix('BSuffAutoreload');
        if (aff != null) {
            if (age % aff.modifierLevel == 0) {
                bool atLeastOneReloaded = false;
                // Iterate through all weapons
                let invlist = owner.Inv;
                while(invlist != null) {
                    let toReload = RandomizedWeapon(invlist);
                    if (toReload && owner.Player.ReadyWeapon != invlist) {
                        let clipBefore = toReload.currentClipAmmo;
                        toReload.A_MagazineReload();
                        atLeastOneReloaded = atLeastOneReloaded || (toReload.currentClipAmmo > clipBefore);
                    }
                    invlist=invlist.Inv;
                }
                if (atLeastOneReloaded) {
                    A_StartSound("misc/w_pkup"); // plays Doom's "weapon pickup" sound
                }
            }
            return; // There may be no other suffix anyway
        }

        aff = findAppliedAffix('BSuffBetterMedikits');
        // Caution here: this affix-caused healing may chain-trigger itself on next tick.
        // To prevent that the min allowed lastHealedBy should be bigger than the max affix heal amount.
        if (aff != null && RwPlayer(owner).lastHealedBy >= 10 && RwPlayer(owner).lastHealedBy > aff.modifierLevel) {
            owner.GiveBody(aff.modifierLevel, 100);
        }

    }

    override bool HandlePickup(Inventory pickedUp) {
        if (pickedUp is 'Ammo') {
            let aff = findAppliedAffix('BSuffMoreAmmoChance');
            if (aff != null && rnd.PercentChance(aff.modifierLevel)) {
                if (pickedUp.Amount < 3) {
                    pickedUp.amount = rnd.Rand(pickedUp.amount, 2*pickedUp.amount);
                } else {
                    pickedUp.amount = rnd.Rand(pickedUp.amount, 3*pickedUp.amount/2);
                }
                return false;
            }
            aff = findAppliedAffix('BSuffLessAmmoChance');
            if (aff != null && rnd.PercentChance(aff.modifierLevel)) {
                if (pickedUp.Amount > 2) {
                    pickedUp.amount = rnd.Rand(pickedUp.amount/2, pickedUp.amount);
                }
                return false;
            }
        }
		return false;
    }
}