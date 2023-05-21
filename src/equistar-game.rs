#![no_std]

multiversx_sc::imports!();

mod storage;

#[multiversx_sc::contract]
pub trait EquistarGameContract: storage::StorageModule {
    #[init]
    fn init(&self, token_identifier: TokenIdentifier) {
        self.token_identifier().set(&token_identifier);
    }

    #[only_owner]
    #[endpoint(updateTicketPriceInEstar)]
    fn update_ticket_price_in_estar(&self, ticket_price: BigUint) {
        self.ticket_price_in_estar().set(&ticket_price);
    }

    #[only_owner]
    #[endpoint(updateTicketPriceInEgld)]
    fn update_ticket_price_in_egld(&self, ticket_price: BigUint) {
        self.ticket_price_in_egld().set(&ticket_price);
    }

    #[only_owner]
    #[endpoint(setStablePriceInEstar)]
    fn set_stable_price_in_estar(&self, level: u64, stable_price: BigUint) {
        self.stable_price_in_estar(&level).set(stable_price);
    }

    #[only_owner]
    #[endpoint(setStablePriceInEgld)]
    fn set_stable_price_in_egld(&self, level: u64, stable_price: BigUint) {
        self.stable_price_in_egld(&level).set(stable_price);
    }

    #[only_owner]
    #[endpoint(setStableMaxLevel)]
    fn set_stable_max_level(&self, level: u64) {
        self.stable_max_level().set(level);
    }

    #[only_owner]
    #[endpoint(setUserStable)]
    fn set_user_stable(&self, address: ManagedAddress, level: u64) {
        self.user_stable(&address).set(level);
    }

    #[only_owner]
    #[endpoint(setFarmPriceInEstar)]
    fn set_farm_price_in_estar(&self, level: u64, farm_price: BigUint) {
        self.farm_price_in_estar(&level).set(farm_price);
    }

    #[only_owner]
    #[endpoint(setFarmPriceInEgld)]
    fn set_farm_price_in_egld(&self, level: u64, farm_price: BigUint) {
        self.farm_price_in_egld(&level).set(farm_price);
    }

    #[only_owner]
    #[endpoint(setFarmMaxLevel)]
    fn set_farm_max_level(&self, level: u64) {
        self.farm_max_level().set(level);
    }

    #[only_owner]
    #[endpoint(setUserFarm)]
    fn set_user_farm(&self, address: ManagedAddress, level: u64) {
        self.user_farm(&address).set(level);
    }

    #[only_owner]
    #[endpoint(withdrawEgld)]
    fn withdraw_egld(&self) {
        let caller = self.blockchain().get_caller();
        let balance = self.blockchain().get_sc_balance(&EgldOrEsdtTokenIdentifier::egld(), 0);
        self.send().direct_egld(&caller, &balance);
    }

    #[only_owner]
    #[endpoint(withdrawEstar)]
    fn withdraw_estar(&self) {
        let caller = self.blockchain().get_caller();
        let token = self.token_identifier().get();
        let balance = self.blockchain().get_sc_balance(&EgldOrEsdtTokenIdentifier::esdt(token.clone()), 0);
        self.send().direct_esdt(&caller, &token, 0, &balance);
    }
    
    #[payable("*")]
    #[endpoint(buyTickets)]
    fn buy_tickets(&self) -> BigUint {
        let (token_identifier, _token_nonce, amount) = self.call_value().egld_or_single_esdt().into_tuple();

        require!(
            token_identifier == self.token_identifier().get() || token_identifier.is_egld(),
            "Invalid token!"
        );

        let mut number_of_tickets = BigUint::zero();
        let caller = self.blockchain().get_caller();

        if token_identifier.is_egld() {
            require!(
                amount >= self.ticket_price_in_egld().get(),
                "You must buy at least one ticket!"
            );
            number_of_tickets = amount.clone() / self.ticket_price_in_egld().get();

        } else {
            require!(
                amount >= self.ticket_price_in_estar().get(),
                "You must buy at least one ticket!"
            );
            number_of_tickets = amount.clone() / self.ticket_price_in_estar().get();
        }

        self.total_tickets_per_address(&caller)
            .update(|total_tickets| *total_tickets += number_of_tickets.clone());
        
        number_of_tickets
    }

    #[payable("*")]
    #[endpoint(upgradeStable)]
    fn upgrade_stable(&self) -> u64 {
        let (token_identifier, _token_nonce, amount) = self.call_value().egld_or_single_esdt().into_tuple();

        require!(
            token_identifier == self.token_identifier().get() || token_identifier.is_egld(),
            "Invalid token!"
        );

        let caller = self.blockchain().get_caller();
        let mut user_stable = self.user_stable(&caller).get();

        require!(
            user_stable < self.stable_max_level().get(),
            "You have already reached the maximum level!"
        );

        if token_identifier.is_egld() {
            require!(
                amount == self.stable_price_in_egld(&(&user_stable + &1)).get(),
                "You must pay the stable price!"
            );
            user_stable += 1;

        } else {
            require!(
                amount == self.stable_price_in_estar(&(&user_stable + &1)).get(),
                "You must pay the stable price!"
            );
            user_stable += 1;
        }

        self.user_stable(&caller).set(user_stable);
        user_stable
    }

    #[payable("*")]
    #[endpoint(upgradeFarm)]
    fn upgrade_farm(&self) -> u64 {
        let (token_identifier, _token_nonce, amount) = self.call_value().egld_or_single_esdt().into_tuple();

        require!(
            token_identifier == self.token_identifier().get() || token_identifier.is_egld(),
            "Invalid token!"
        );

        let caller = self.blockchain().get_caller();
        let mut user_farm = self.user_farm(&caller).get();

        require!(
            user_farm < self.farm_max_level().get(),
            "You have already reached the maximum level!"
        );

        if token_identifier.is_egld() {
            require!(
                amount == self.farm_price_in_egld(&(&user_farm + &1)).get(),
                "You must pay the farm price!"
            );
            user_farm += 1;

        } else {
            require!(
                amount == self.farm_price_in_estar(&(&user_farm + &1)).get(),
                "You must pay the farm price!"
            );
            user_farm += 1;
        }

        self.user_farm(&caller).set(user_farm);
        user_farm
    }

}
