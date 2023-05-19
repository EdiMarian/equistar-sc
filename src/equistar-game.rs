#![no_std]

multiversx_sc::imports!();

mod storage;

#[multiversx_sc::contract]
pub trait EquistarGameContract: storage::StorageModule {
    #[init]
    fn init(&self, token_identifier: TokenIdentifier, ticket_price: BigUint) {
        self.token_identifier().set(&token_identifier);
        self.ticket_price_in_estar().set(&ticket_price);
        self.ticket_price_in_egld().set(&ticket_price);
    }

    #[only_owner]
    #[endpoint(updatePriceInEstar)]
    fn update_price_in_estar(&self, ticket_price: BigUint) {
        self.ticket_price_in_estar().set(&ticket_price);
    }

    #[only_owner]
    #[endpoint(updatePriceInEgld)]
    fn update_price_in_egld(&self, ticket_price: BigUint) {
        self.ticket_price_in_egld().set(&ticket_price);
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

        let owner = self.blockchain().get_owner_address();
        self.send()
            .direct(&owner, &token_identifier, 0, &amount);
        
        number_of_tickets
    }
}
