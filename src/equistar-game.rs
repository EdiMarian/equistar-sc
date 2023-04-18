#![no_std]

multiversx_sc::imports!();

mod storage;

#[multiversx_sc::contract]
pub trait EquistarGameContract: storage::StorageModule {
    #[init]
    fn init(&self, token_identifier: TokenIdentifier, ticket_price: BigUint) {
        self.token_identifier().set(&token_identifier);
        self.ticket_price().set(&ticket_price);
    }

    #[payable("*")]
    #[endpoint(buyTickets)]
    fn buy_tickets(&self) -> SCResult<BigUint> {
        let (token_identifier, _token_nonce, amount) = self.call_value().single_esdt().into_tuple();

        require!(
            token_identifier == self.token_identifier().get(),
            "Invalid token!"
        );

        require!(
            amount >= self.ticket_price().get(),
            "You must buy at least one ticket!"
        );

        let number_of_tickets = amount.clone() / self.ticket_price().get();
        let caller = self.blockchain().get_caller();

        self.total_tickets_per_address(&caller)
            .update(|total_tickets| *total_tickets += number_of_tickets.clone());

        let owner = self.blockchain().get_owner_address();
        self.send()
            .direct_esdt(&owner, &token_identifier, 0, &amount);
        
        Ok(number_of_tickets)
    }
}
