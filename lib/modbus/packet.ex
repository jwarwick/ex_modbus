defmodule Modbus.Packet do
  @moduledoc """
  Handle Modbus packet creation and parsing.
  """

  # Function Codes
  @read_coils             0x01
  @read_discrete_inputs   0x02
  @read_holding_registers 0x03
  @read_input_registers   0x04

  defmacrop read_multiple(function_code, starting_address, count) do
    quote do
      <<unquote(function_code), (unquote(starting_address)-1)::size(16)-big, unquote(count)::size(16)-big>>
    end
  end

  @doc """
  Read status from a contiguous range of coils.
  `starting_address` is 1-indexed.
  """
  def read_coils(starting_address, count) do
    read_multiple(@read_coils, starting_address, count)
  end

  @doc """
  Read status from a contiguous range of discrete inputs.
  `starting_address` is 1-indexed.
  """
  def read_discrete_inputs(starting_address, count) do
    read_multiple(@read_discrete_inputs, starting_address, count)
  end

  @doc """
  Read the contents of a contiguous block of holding registers.
  `starting_address` is 1-indexed.
  """
  def read_holding_registers(starting_address, count) do
    read_multiple(@read_holding_registers, starting_address, count)
  end

  @doc """
  Read the contents of a contiguous block of input registers.
  `start_address` is 1-indexed.
  """
  def read_input_registers(starting_address, count) do
    read_multiple(@read_input_registers, starting_address, count)
  end

  
end

