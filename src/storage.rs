multiversx_sc::imports!();

#[multiversx_sc::module]
pub trait StorageModule {
    #[storage_mapper("token_identifier")]
    fn token_identifier(&self) -> SingleValueMapper<TokenIdentifier>;

    #[view(getTicketPriceInEstar)]
    #[storage_mapper("ticket_price_in_estar")]
    fn ticket_price_in_estar(&self) -> SingleValueMapper<BigUint>;

    #[view(getTicketPriceInEgld)]
    #[storage_mapper("ticket_price_in_egld")]
    fn ticket_price_in_egld(&self) -> SingleValueMapper<BigUint>;

    #[view(getTotalTicketsPerAddress)]
    #[storage_mapper("total_tickets_per_address")]
    fn total_tickets_per_address(&self, address: &ManagedAddress) -> SingleValueMapper<BigUint>;

    #[view(getStablePriceInEstar)]
    #[storage_mapper("stable_price_in_estar")]
    fn stable_price_in_estar(&self, level: &u64) -> SingleValueMapper<BigUint>;

    #[view(getStablePriceInEgld)]
    #[storage_mapper("stable_price_in_egld")]
    fn stable_price_in_egld(&self, level: &u64) -> SingleValueMapper<BigUint>;

    #[view(getUserStable)]
    #[storage_mapper("user_stable")]
    fn user_stable(&self, address: &ManagedAddress) -> SingleValueMapper<u64>;
}