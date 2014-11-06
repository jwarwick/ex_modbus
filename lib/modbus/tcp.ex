defmodule Modbus.Tcp do
  @moduledoc """
  Wrap and parse Modbus TCP packets. 
  """

  @protocol_id 0x0000

  @doc """
  Wrap `packet` in the Modbus Application Header appropriate for TCP/IP transport.
  """
  def wrap_packet(transaction_id \\ 0, unit_id \\ 0, packet) do
    <<transaction_id::size(16)-big, @protocol_id::size(16)-big, (1 + byte_size(packet))::size(16)-big,
      unit_id, packet::binary>>
  end
end
