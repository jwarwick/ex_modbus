defmodule Modbus.Tcp do
  @moduledoc """
  Wrap and parse Modbus TCP packets. 
  """

  @protocol_id 0x0000
  @default_port_number 502

  @doc """
  Wrap `packet` in the Modbus Application Header appropriate for TCP/IP transport.
  """
  def wrap_packet(packet, transaction_id \\ 1, unit_id \\ 1) do
    <<transaction_id::size(16)-big, @protocol_id::size(16)-big, (1 + byte_size(packet))::size(16)-big,
      unit_id, packet::binary>>
  end

  @doc """
  The default ModbusTCP port number
  """
  def port, do: @default_port_number
end
