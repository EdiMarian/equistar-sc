multiversx_sc::imports!();

#[multiversx_sc::module]
pub trait StorageModule {
    #[storage_mapper("token_identifier")]
    fn token_identifier(&self) -> SingleValueMapper<TokenIdentifier>;

    #[storage_mapper("ticket_price")]
    fn ticket_price(&self) -> SingleValueMapper<BigUint>;

    #[view(getTotalTicketsPerAddress)]
    #[storage_mapper("total_tickets_per_address")]
    fn total_tickets_per_address(&self, address: &ManagedAddress) -> SingleValueMapper<BigUint>;
}