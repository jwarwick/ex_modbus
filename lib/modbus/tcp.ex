defmodule Modbus.Tcp do
  @moduledoc """
  Wrap and parse Modbus TCP packets. 
  """

  @protocol_id 0x0000
  @default_port_number 502

  @doc """
  Wrap `packet` in the Modbus Application Header appropriate for TCP/IP transport.
  """
  def wrap_packet(packet, unit_id, transaction_id \\ 1) do
    <<transaction_id::size(16)-big, @protocol_id::size(16)-big, (1 + byte_size(packet))::size(16)-big,
      unit_id, packet::binary>>
  end

  @doc """
  Unwrap the Modbus Application Header from a packet
  """
  def unwrap_packet(<<transaction_id::size(16)-big, 
                      @protocol_id::size(16)-big, 
                      packet_size::size(16)-big,
                      unit_id, 
                      packet::binary>>) do
    %{transaction_id: transaction_id, unit_id: unit_id, packet_size: packet_size - 1, packet: packet}
  end

  @doc """
  The default ModbusTCP port number
  """
  def port, do: @default_port_number
end
