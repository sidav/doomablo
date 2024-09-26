extend class RandomizedWeapon {

    int currentClipAmmo;

    // All the arguments are there just because it's an override (so they're partially unused and it's on purpose)
    override bool checkAmmo(int fireMode, bool autoSwitch, bool requireAmmo, int ammocount)
	{
        // Uses clip
        if (stats.reloadable() && currentClipAmmo >= stats.ammoUsage) {
            return true;
        }

        // Doesn't use clip
		let count1 = (Ammo1 != null) ? Ammo1.Amount : 0;
		let count2 = (Ammo2 != null) ? Ammo2.Amount : 0;
        if (count1 >= stats.ammoUsage) {
            return true;
        } else {
            if (autoSwitch) {
                MyPlayer(Owner).PickNewWeapon(null);
            }
            return false;
        }
	}

    // All the arguments are there just because it's an override (so they're partially unused and it's on purpose)
    override bool depleteAmmo(bool altFire, bool checkEnough, int ammouse, bool forceammouse) {
        if (stats.freeShotPeriod > 0) {
            shotsSinceLastFreeShot++;
        }
        if (stats.freeShotPeriod > 0 && shotsSinceLastFreeShot % stats.freeShotPeriod == 0) {
            shotsSinceLastFreeShot = 0; // and don't consume ammo!
            return true;
        } else {
            if (checkAmmo(0, true, true, stats.ammoUsage)) {
                if (stats.reloadable()) {
                    currentClipAmmo -= stats.ammoUsage;
                } else {
                    Ammo1.Amount -= stats.ammoUsage;
                }
                return true;
            } else {
                return false;
            }
        }
    }

    // Takes care of ammo
    action void RWA_ReFire() {
        if (invoker.stats.reloadable()) {
            if (invoker.currentClipAmmo < invoker.stats.ammoUsage) {
                return;
            }
        }
        A_ReFire();
    }

    action state RWA_ReloadOrSwitchIfEmpty() {
        if (invoker.currentClipAmmo < invoker.stats.ammoUsage) {
            if (invoker.ammo1.amount > invoker.stats.ammoUsage) {
                return ResolveState("Reload");
            }
            MyPlayer(invoker.Owner).PickNewWeapon(null);
            return ResolveState(null);    
        }
        return ResolveState(null);
    }

    // Call this instead of A_WeaponReady()
    action void RWA_WeaponReadyReload(int flags = 0)
    {
        if (invoker.currentClipAmmo < invoker.stats.clipSize && invoker.ammo1.amount >= invoker.stats.ammoUsage) {
            flags |= WRF_ALLOWRELOAD;
        }
        A_WeaponReady(flags);
    }

    action void A_MagazineReload()
    {
        while (invoker.ammo1.amount >= invoker.stats.ammoUsage && invoker.currentClipAmmo < invoker.stats.clipSize) {
            invoker.ammo1.amount--;
            invoker.currentClipAmmo++;
        }
    }
}